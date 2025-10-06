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
    
    @Namespace var animationNamespace
    @State var showSettingsCover: Bool = false
    @State var errorHaptic: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 12) {
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
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                }
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("DASHBOARD")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
            .fullScreenCover(isPresented: $showSettingsCover) {
                SettingsView()
                    .navigationTransition(.zoom(sourceID: "Settings", in: animationNamespace))
            }
        }
        .safeAreaBar(edge: .bottom, spacing: 0) {
            HStack {
                GlassEffectContainer {
                    HStack {
                        Button {
                            showSettingsCover.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "gearshape.fill")
                                    .imageScale(.large)
                            }
                            .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        .matchedTransitionSource(id: "Settings", in: animationNamespace)
                        
                        Button {
                            globalVM.showEvaluationAccounts.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "graduationcap.circle\(globalVM.showEvaluationAccounts ? ".fill" : "")")
                                    .imageScale(.large)
                            }
                            .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            globalVM.showFundedAccounts.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "creditcard.circle\(globalVM.showFundedAccounts ? ".fill" : "")")
                                    .imageScale(.large)
                            }
                            .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                        
                        Button {
                            globalVM.showPracticeAccounts.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "lightbulb.circle\(globalVM.showPracticeAccounts ? ".fill" : "")")
                                    .imageScale(.large)
                            }
                            .frame(width: 44, height: 44)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 12))
                
                Spacer()
                
                Button {
                    errorHaptic.toggle()
                    Task {
                        globalVM.refreshingAccounts = true
                        await withTaskGroup(of: Void.self) { group in
                            for firm in Firm.allCases {
                                if globalVM.isConnected(firm) {
                                    group.addTask {
                                        await globalVM.loadAccounts(firm)
                                    }
                                }
                            }
                        }
                        globalVM.refreshingAccounts = false
                    }
                } label: {
                    ZStack {
                        Image(systemName: "livephoto")
                            .imageScale(.large)
                            .symbolEffect(.bounce, options: globalVM.refreshingAccounts ? .repeating : .nonRepeating, value: globalVM.refreshingAccounts)
                    }
                    .frame(width: 44, height: 44)
                    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.error, trigger: errorHaptic)
            }
            .padding(.horizontal)
            .padding(.horizontal)
        }
    }
}

#Preview {
    AppShell()
}
