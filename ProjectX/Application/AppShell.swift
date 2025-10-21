//
//  AppShell.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import Combine
import SwiftUI

struct AppShell: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var showSettingsCover: Bool = false
    @State var successHaptic: Bool = false
    @State var errorHaptic: Bool = false
    
    let refreshTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                                    && ((globalVM.hideLockedAccounts && !globalVM.isLocked(firm, $0)) || !globalVM.hideLockedAccounts)
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
                    Button {
                        errorHaptic.toggle()
                        if globalVM.isInitialized {
                            Task {
                                await globalVM.refreshData()
                            }
                        }
                    } label: {
                        Image(systemName: "livephoto")
                            .symbolEffect(.bounce, options: globalVM.refreshingData ? .repeating : .nonRepeating, value: globalVM.refreshingData)
                            .imageScale(.small)
                            .padding()
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.error, trigger: errorHaptic)
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
                            .padding()
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .fullScreenCover(isPresented: $showSettingsCover) {
                SettingsView()
            }
            .onReceive(refreshTimer) { _ in
                if globalVM.isInitialized && globalVM.automaticRefresh {
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
