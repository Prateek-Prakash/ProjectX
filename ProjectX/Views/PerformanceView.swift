//
//  PerformanceView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import SwiftUI

struct PerformanceView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var successHaptic: Bool = false
    
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
                        VStack {
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
                                        Text("PERSONAL LIMITS")
                                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                            .tracking(2)
                                            .foregroundStyle(Color(.xHeaderText))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    VStack(spacing: 0) {
                                        Button {
                                            // TODO: Edit PDPT
                                        } label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Daily Profit Target")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Text(account.personalDailyProfitTarget?.asCurrency() ?? "--")
                                                        .font(.system(size: 12, design: .rounded))
                                                        .foregroundStyle(.secondary)
                                                    Image(systemName: "chevron.right")
                                                        .foregroundStyle(.secondary)
                                                        .fontDesign(.rounded)
                                                        .imageScale(.small)
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
                                            // TODO: Edit PDLL
                                        } label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Daily Loss Limit")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Text(account.personalDailyLossLimit?.asCurrency() ?? "--")
                                                        .font(.system(size: 12, design: .rounded))
                                                        .foregroundStyle(.secondary)
                                                    Image(systemName: "chevron.right")
                                                        .foregroundStyle(.secondary)
                                                        .fontDesign(.rounded)
                                                        .imageScale(.small)
                                                }
                                                .frame(height: 12)
                                            }
                                            .backgroundStyle(Color(.xCardBackground))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
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
                                        DailyStatsHistoryView()
                                    } label: {
                                        OriginHeader {
                                            Text("LATEST DAILY STATS")
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
                                        if !globalVM.accountDailyStats.isEmpty {
                                            ForEach(Array(globalVM.accountDailyStats.prefix(5))) { stats in
                                                DailyStatsTile(stats: stats)
                                                if globalVM.accountDailyStats.last != stats {
                                                    Divider()
                                                        .frame(height: 1)
                                                        .overlay(Color(.xOutline))
                                                }
                                            }
                                        } else {
                                            ContentUnavailableView {
                                                Label("NO DAILY STATS", systemImage: "exclamationmark.triangle")
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
                            
                            OriginCard {
                                VStack(spacing: 0) {
                                    OriginHeader {
                                        Text("ANALYSIS")
                                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                            .tracking(2)
                                            .foregroundStyle(Color(.xHeaderText))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    VStack(spacing: 0) {
                                        NavigationLink {
                                            TradeTimeView()
                                        }  label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Trade Time")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundStyle(.secondary)
                                                        .fontDesign(.rounded)
                                                        .imageScale(.small)
                                                }
                                                .frame(height: 12)
                                            }
                                            .backgroundStyle(Color(.xCardBackground))
                                        }
                                        .buttonStyle(.plain)
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        NavigationLink {
                                            TradeDurationView()
                                        }  label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Trade Duration")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundStyle(.secondary)
                                                        .fontDesign(.rounded)
                                                        .imageScale(.small)
                                                }
                                                .frame(height: 12)
                                            }
                                            .backgroundStyle(Color(.xCardBackground))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    NavigationLink {
                                        WinRateView()
                                    }  label: {
                                        GroupBox {
                                            HStack {
                                                Text("Win Rate")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.secondary)
                                                    .fontDesign(.rounded)
                                                    .imageScale(.small)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                    .buttonStyle(.plain)
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            successHaptic.toggle()
                            await globalVM.loadDailyStats(account)
                            await globalVM.loadTrades(account)
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.success, trigger: successHaptic)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        .interactiveDismissDisabled()
    }
}
