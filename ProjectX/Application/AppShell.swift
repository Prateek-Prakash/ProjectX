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
    
    let oneSecondTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let twoSecondTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !globalVM.isInitialized {
                    ProgressView()
                } else if !globalVM.allAccounts.isEmpty {
                    ScrollView {
                        VStack(spacing: 10) {
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
                            renderedImage
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                } else {
                    
                    ContentUnavailableView {
                        Label("NO ACCOUNTS", systemImage: "exclamationmark.triangle")
                            .imageScale(.small)
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettingsCover.toggle()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("DASHBOARD")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        successHaptic.toggle()
                        // TODO: Screenshot
                    } label: {
                        Image(systemName: "camera.fill")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.success, trigger: successHaptic)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .fullScreenCover(isPresented: $showSettingsCover) {
                SettingsView()
            }
            .onReceive(oneSecondTimer) { _ in
                if globalVM.isInitialized {
                    globalVM.inTradingHours = !globalVM.isMarketClosed()
                }
            }
            .onReceive(twoSecondTimer) { _ in
                if globalVM.isInitialized {
                    Task {
                        await globalVM.refreshData()
                    }
                }
            }
        }
    }
}

#Preview {
    AppShell()
}
