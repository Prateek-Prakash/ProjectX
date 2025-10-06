//
//  FirmSettingsCard.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/24/25.
//

import SwiftUI

struct FirmSettingsCard: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let firm: Firm
    
    @State var successHaptic: Bool = false
    @State var isRotating = 0.0
    
    @State var showAuthSheet: Bool = false
    
    var body: some View {
        OriginCard {
            VStack(spacing: 0) {
                Button {
                    globalVM.loadCredentials(firm)
                    showAuthSheet.toggle()
                } label: {
                    OriginHeader {
                        Text("\(firm.headerName) • \(globalVM.allAccounts.filter({ $0.firm == firm }).count)")
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(Color(.xHeaderText))
                        Spacer()
                        if globalVM.authenticatingStates[firm]! {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                                .foregroundStyle(.primary)
                                .shadow(color: .primary, radius: 3)
                                .symbolEffect(.pulse, options: .repeating)
                        } else if globalVM.isLinked(firm) && globalVM.connectedStates[firm]! {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                                .foregroundStyle(.green)
                                .shadow(color: .green, radius: 3)
                        } else if globalVM.isLinked(firm) && !globalVM.connectedStates[firm]! {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                                .foregroundStyle(.red)
                                .shadow(color: .red, radius: 3)
                        } else {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                                .foregroundStyle(.gray)
                                .shadow(color: .gray, radius: 3)
                        }
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                
                if globalVM.isLinked(firm) && globalVM.isConnected(firm) {
                    if globalVM.allAccounts.contains(where: { $0.firm == firm}) {
                        Divider()
                            .frame(height: 1)
                            .overlay(Color(.xOutline))
                        
                        ZStack {
                            VStack(spacing: 0) {
                                let accounts = globalVM.allAccounts.filter({ $0.firm == firm })
                                ForEach(accounts) { account in
                                    Button {
                                        successHaptic.toggle()
                                        globalVM.rotateAccountType(account)
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "circle")
                                                    .font(.system(size: 6))
                                                    .foregroundStyle(account.accountType.typeColor)
                                                    .shadow(color: account.accountType.typeColor, radius: 3)
                                                    .shadow(color: account.accountType.typeColor, radius: 3)
                                                Text(account.accountName)
                                                    .font(.system(size: 10, design: .monospaced))
                                                Spacer()
                                                Image(systemName: "l.square.fill")
                                                    .foregroundStyle(account.isLeader ? Color.primary : .gray.mix(with: .black, by: 0.3))
                                                Image(systemName: "f.square")
                                                    .foregroundStyle(account.isFollower ? Color.primary : .gray.mix(with: .black, by: 0.3))
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                    .buttonStyle(.plain)
                                    .sensoryFeedback(.success, trigger: successHaptic)
                                    
                                    if accounts.last != account {
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                    }
                                }
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAuthSheet) {
            CredentialsView(firm: firm)
        }
    }
}
