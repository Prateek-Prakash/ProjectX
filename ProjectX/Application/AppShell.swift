//
//  AppShell.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import Combine
import SwiftData
import SwiftUI

struct AppShell: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\RawBackup.firm), SortDescriptor(\RawBackup.name)]) var rawBackups: [RawBackup]
    
    @State var showSettingsCover: Bool = false
    @State var successHaptic: Bool = false
    
    @State var triggerSnapshot: Bool = false
    @State var uiSnapshot: UIImage? = nil
    @State var snapshotPadding: Bool = false
    
    let refreshTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        ForEach(Firm.allCases) { firm in
                            if globalVM.isLinked(firm) && globalVM.isConnected(firm) {
                                let accounts = globalVM.allAccounts.filter({
                                    $0.firm == firm
                                    && ((globalVM.showEvaluationAccounts && $0.accountType == .evaluation) || (globalVM.showFundedAccounts && $0.accountType == .funded) || (globalVM.showPracticeAccounts && $0.accountType == .practice))
                                    && ((globalVM.hideLockedAccounts && $0.canTrade) || !globalVM.hideLockedAccounts)
                                })
                                if !globalVM.hideEmptyFirms || !accounts.isEmpty {
                                    FirmCard(
                                        firm: firm,
                                        accounts: accounts
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "livephoto")
                        .symbolEffect(.bounce, options: globalVM.refreshingData ? .repeating : .nonRepeating, value: globalVM.refreshingData)
                        .imageScale(.small)
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("DASHBOARD")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettingsCover.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .fullScreenCover(isPresented: $showSettingsCover) {
                SettingsView()
            }
            .onReceive(refreshTimer) { _ in
                if globalVM.isInitialized {
                    if globalVM.automaticRefresh {
                        Task {
                            await globalVM.refreshData()
                        }
                    }
                    if globalVM.automaticBackup {
                        Task {
                            await backupAccounts()
                        }
                    }
                }
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

#Preview {
    AppShell()
}
