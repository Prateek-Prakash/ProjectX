//
//  CustomizationView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SwiftUI

struct CustomizationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
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
                                            .fontDesign(.rounded)
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
                                            .fontDesign(.rounded)
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
                                            .fontDesign(.rounded)
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
                        Button {
                            globalVM.hideEmptyFirms.toggle()
                        } label: {
                            GroupBox {
                                HStack {
                                    Text("Hide Empty Firms")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .fontDesign(.rounded)
                                    Spacer()
                                    Toggle("", isOn: $globalVM.hideEmptyFirms)
                                        .scaleEffect(0.6, anchor: .trailing)
                                }
                                .frame(height: 12)
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                        .buttonStyle(.plain)
                    }
                    
                    OriginCard {
                        Button {
                            globalVM.hideLockedAccounts.toggle()
                        } label: {
                            GroupBox {
                                HStack {
                                    Text("Hide Locked Accounts")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .fontDesign(.rounded)
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
                    
                    OriginCard {
                        Button {
                            globalVM.subtractStartingBalance.toggle()
                        } label: {
                            GroupBox {
                                HStack {
                                    Text("Subtract Starting Balance")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .fontDesign(.rounded)
                                    Spacer()
                                    Toggle("", isOn: $globalVM.subtractStartingBalance)
                                        .scaleEffect(0.6, anchor: .trailing)
                                }
                                .frame(height: 12)
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("CUSTOMIZATION")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
