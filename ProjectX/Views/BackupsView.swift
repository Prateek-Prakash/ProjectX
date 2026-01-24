//
//  BackupsView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/21/25.
//

import SwiftData
import SwiftUI

struct BackupsView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\RawBackup.firm), SortDescriptor(\RawBackup.name)]) var rawBackups: [RawBackup]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !rawBackups.isEmpty {
                    List {
                        ForEach(rawBackups) { backup in
                            HStack(spacing: 16) {
                                Image(backup.firm.replacingOccurrences(of: " ", with: "-"))
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .clipShape(.circle)
                                    .overlay {
                                        Circle()
                                            .stroke(.secondary, lineWidth: 0.5)
                                    }
                                VStack(alignment: .leading) {
                                    Text(backup.firm)
                                        .font(.system(size: 8, weight: .light, design: .rounded))
                                        .foregroundStyle(Color.xHeaderText)
                                    Text(backup.name)
                                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    Text(backup.timestamp)
                                        .font(.system(size: 8, weight: .medium, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Button {
                                    HapticViewModel.shared.successHaptic()
                                    UIPasteboard.general.string = backup.json
                                } label: {
                                    Image(systemName: "document.on.document")
                                        .foregroundStyle(.secondary)
                                        .fontDesign(.rounded)
                                        .imageScale(.small)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(backup)
                                    try? modelContext.save()
                                } label: {
                                    Image(systemName: "minus.circle")
                                }
                            }
                        }
                        .listRowBackground(Color.xBackground)
                    }
                    .listStyle(.plain)
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
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        HapticViewModel.shared.errorHaptic()
                        Task {
                            await backupAccounts()
                        }
                    } label: {
                        Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
    
    func backupAccounts() async {
        for account in globalVM.allAccounts {
            let existing = rawBackups.first(where: { $0.firm == account.firm.headerName && $0.name == account.accountName })
            
            let trades = await XClient.get(account.firm).getTrades(account.accountId)
            if !trades.isEmpty {
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
        }
        try? modelContext.save()
    }
}

