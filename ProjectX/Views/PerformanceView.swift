//
//  PerformanceView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import SwiftUI

struct PerformanceView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let account: Account
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if globalVM.loadingTrades {
                    ProgressView()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            OriginCard {
                                VStack(spacing: 0) {
                                    OriginHeader {
                                        Text(account.firm.headerName)
                                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                            .tracking(2)
                                            .foregroundStyle(Color(.xHeaderText))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    ZStack {
                                        AccountTile(account: account, tappable: false)
                                    }
                                }
                            }
                            
                            OriginCard {
                                VStack(spacing: 0) {
                                    OriginHeader {
                                        Text("WIN PERCENTAGE")
                                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                            .tracking(2)
                                            .foregroundStyle(Color(.xHeaderText))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    ZStack {
                                        Gauge(value: account.winRate, in: 0...1) {
                                            // Gauge Label
                                        } currentValueLabel: {
                                            // Current Value
                                        } minimumValueLabel: {
                                            let winPercentage = account.winRate * 100
                                            Text(String(format: "%.0f", winPercentage))
                                                .font(.caption)
                                                .fontDesign(.monospaced)
                                        } maximumValueLabel: {
                                            let lossPercentage = 100 - (account.winRate * 100)
                                            Text(String(format: "%.0f", lossPercentage))
                                                .font(.caption)
                                                .fontDesign(.monospaced)
                                        }
                                        .gaugeStyle(.accessoryLinear)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 14)
                                    }
                                }
                            }
                            
                            OriginCard {
                                VStack(spacing: 0) {
                                    NavigationLink {
                                        TradeHistoryView()
                                    } label: {
                                        OriginHeader {
                                            Text("LATEST TRADES")
                                                .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                                .tracking(2)
                                                .foregroundStyle(Color(.xHeaderText))
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(Color(.xHeaderText))
                                                .font(.system(size: 6, weight: .semibold, design: .rounded))
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    LazyVStack(spacing: 0) {
                                        if !globalVM.accountTrades.isEmpty {
                                            ForEach(Array(globalVM.accountTrades.prefix(5))) { trade in
                                                TradeTile(trade: trade)
                                                if globalVM.accountTrades.last != trade {
                                                    Divider()
                                                        .frame(height: 1)
                                                        .overlay(Color(.xOutline))
                                                }
                                            }
                                        } else {
                                            ContentUnavailableView {
                                                Label("NO TRADES", systemImage: "exclamationmark.triangle")
                                                    .imageScale(.small)
                                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                                    .tracking(2)
                                                    .foregroundStyle(.secondary)
                                            }
                                            .padding()
                                        }
                                    }
                                }
                            }
                        } // VStack
                        .padding(.horizontal)
                        .padding(.bottom)
                    } // ScrollView
                } // If-Else
            } // ZStack
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("PERFORMANCE")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
        .interactiveDismissDisabled()
    }
}
