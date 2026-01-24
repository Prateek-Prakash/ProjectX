//
//  CustomizationSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/24/26.
//

import SwiftUI

struct CustomizationSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var sheetHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xCardBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    OriginCard {
                        VStack(spacing: 0) {
                            OriginHeader {
                                Text("ACCOUNT TYPES")
                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundStyle(Color(.xHeaderText))
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            Button {
                                globalVM.showEvaluationAccounts.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Evaluation Accounts")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.showEvaluationAccounts)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            Button {
                                globalVM.showFundedAccounts.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Funded Accounts")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.showFundedAccounts)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            Button {
                                globalVM.showPracticeAccounts.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Practice Accounts")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.showPracticeAccounts)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    OriginCard {
                        VStack(spacing: 0) {
                            Button {
                                globalVM.hideEmptyFirms.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Hide Empty Firms")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.hideEmptyFirms)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            Button {
                                globalVM.hideLockedAccounts.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Hide Locked Accounts")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.hideLockedAccounts)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    OriginCard {
                        VStack(spacing: 0) {
                            Button {
                                globalVM.subtractStartingBalance.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Subtract Starting Balance")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.subtractStartingBalance)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            Button {
                                globalVM.blurBalances.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Blur Balances")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.blurBalances)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.vertical)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { size in
                    sheetHeight = size.height
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true).toolbar {
                ToolbarItem(placement: .title) {
                    Text("CUSTOMIZATION")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
        .presentationDetents([.height(sheetHeight)])
    }
}
