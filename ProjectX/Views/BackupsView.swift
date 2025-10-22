//
//  BackupsView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/21/25.
//

import SwiftData
import SwiftUI

struct BackupsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RawBackup.name) var rawBackups: [RawBackup]
    
    @State var errorHaptic: Bool = false
    @State var successHaptic: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !rawBackups.isEmpty {
                    List {
                        ForEach(rawBackups) { backup in
                            Button {
                                successHaptic.toggle()
                                UIPasteboard.general.string = backup.json
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(backup.firm)
                                            .font(.system(size: 8, weight: .light, design: .rounded))
                                            .foregroundStyle(Color.xHeaderText)
                                        Text(backup.name)
                                            .font(.system(size: 10, weight: .bold, design: .rounded))
                                        Text(backup.timestamp)
                                            .font(.system(size: 8, weight: .medium, design: .monospaced))
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .contentShape(.rect)
                            }
                            .buttonStyle(.plain)
                            .sensoryFeedback(.success, trigger: successHaptic)
                        }
                        .listRowBackground(Color.xBackground)
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                } else {
                    ContentUnavailableView {
                        Label("NO BACKUPS", systemImage: "exclamationmark.triangle")
                            .imageScale(.small)
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("BACKUPS")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        errorHaptic.toggle()
                        Task {
                            await backupAccounts()
                        }
                    } label: {
                        Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            .imageScale(.small)
                            .padding()
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.error, trigger: errorHaptic)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
    
    func backupAccounts() async {
        for account in globalVM.allAccounts {
            let existing = rawBackups.first(where: { $0.firm == account.firm.headerName && $0.name == account.accountName })
            
            let trades = await XClient.get(account.firm).getTrades(account.accountId)
            let data = try! JSONEncoder().encode(trades)
            let json = String(data: data, encoding: .utf8)!
            
            if existing != nil {
                existing?.update(json)
            } else {
                let backup = RawBackup(
                    firm: account.firm.headerName,
                    name: account.accountName,
                    json: json,
                    timestamp: Date.now.ISO8601Format()
                )
                modelContext.insert(backup)
            }
        }
        try? modelContext.save()
    }
}

