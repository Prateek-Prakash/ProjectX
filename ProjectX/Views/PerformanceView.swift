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
    
    @State var showDailyProfitTargetSheet: Bool = false
    @State var showDailyLossLimitSheet: Bool = false
    @State var isTrailing: Bool = false
    
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
                            HStack {
                                OriginCard {
                                    GroupBox {
                                        HStack {
                                            Button {
                                                // TODO: Lockout
                                                successHaptic.toggle()
                                            } label: {
                                                HStack {
                                                    Image(systemName: "lock.fill")
                                                        .imageScale(.small)
                                                    Text("LOCKOUT")
                                                        .tracking(2)
                                                        .font(.system(size: 10, weight: .medium, design: .rounded))
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(.red)
                                            }
                                            .buttonStyle(.plain)
                                            .disabled(!account.canTrade)
                                        }
                                        .frame(height: 12)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                } color: {
                                    Color(.red)
                                }
                                
                                OriginCard {
                                    GroupBox {
                                        HStack {
                                            Button {
                                                // TODO: Flatten
                                                successHaptic.toggle()
                                            } label: {
                                                HStack {
                                                    Image(systemName: "exclamationmark.octagon.fill")
                                                        .imageScale(.small)
                                                    Text("FLATTEN")
                                                        .tracking(2)
                                                        .font(.system(size: 10, weight: .medium, design: .rounded))
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(.yellow)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                        .frame(height: 12)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                } color: {
                                    Color(.yellow)
                                }
                            }
                            
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
                                        Text("POSITIONS")
                                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                            .tracking(2)
                                            .foregroundStyle(Color(.xHeaderText))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    LazyVStack(spacing: 0) {
                                        if !account.positions.isEmpty {
                                            ForEach(account.positions) { position in
                                                HStack {
                                                    HStack {
                                                        Image(systemName: position.size < 0 ? "arrowtriangle.up.fill" : position.size > 0 ? "arrowtriangle.down.fill" : "questionmark")
                                                            .resizable()
                                                            .frame(width: 8, height: 8)
                                                            .foregroundStyle(position.size < 0 ? .green : position.size > 0 ? .red : .primary)
                                                        Text(contractMap[position.symbolId] ?? "--")
                                                            .font(.system(size: 10, weight: .bold, design: .rounded))
                                                        Spacer()
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                    
                                                    VStack(alignment: .center) {
                                                        Text(String(abs(position.size)))
                                                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                                        Text("CONTRACTS")
                                                            .font(.system(size: 6, design: .monospaced))
                                                            .foregroundStyle(.secondary)
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                    
                                                    HStack {
                                                        Spacer()
                                                        VStack(alignment: .trailing) {
                                                            Text(position.averagePrice.asCurrency())
                                                                .font(.system(size: 10, weight: .bold, design: .rounded))
                                                        }
                                                    }
                                                    .frame(maxWidth: .infinity)
                                                }
                                                .padding(.all, 14)
                                                
                                                if account.positions.last != position {
                                                    Divider()
                                                        .frame(height: 1)
                                                        .overlay(Color(.xOutline))
                                                }
                                            }
                                        } else {
                                            ContentUnavailableView {
                                                Label("NO POSITIONS", systemImage: "exclamationmark.triangle")
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
                                            showDailyProfitTargetSheet.toggle()
                                        } label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Daily Profit Target")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Text(account.personalDailyProfitTarget?.asCurrency() ?? "--")
                                                        .font(.system(size: 12, design: .rounded))
                                                        .foregroundStyle(.secondary)
                                                    Image(systemName: account.personalDailyProfitTargetAction == 2 ? "multiply.square" : account.personalDailyProfitTargetAction == 1 ? "minus.square" : "square")
                                                        .foregroundStyle(.secondary)
                                                        .fontDesign(.rounded)
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
                                            showDailyLossLimitSheet.toggle()
                                        } label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Daily Loss Limit")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Text(account.personalDailyLossLimit?.asCurrency() ?? "--")
                                                        .font(.system(size: 12, design: .rounded))
                                                        .foregroundStyle(.secondary)
                                                    Image(systemName: account.personalDailyLossLimitAction == 2 ? "multiply.square" : account.personalDailyLossLimitAction == 1 ? "minus.square" : "square")
                                                        .foregroundStyle(.secondary)
                                                        .fontDesign(.rounded)
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
                                            isTrailing.toggle()
                                        } label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Trailing Loss Limit")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Toggle("", isOn: $isTrailing)
                                                        .scaleEffect(0.6, anchor: .trailing)
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
            .scrollIndicators(.never)
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
            .sheet(isPresented: $showDailyProfitTargetSheet) {
                DailyProfitTargetView(account: account)
            }
            .sheet(isPresented: $showDailyLossLimitSheet) {
                DailyLossLimitView(account: account)
            }
            .onAppear {
                isTrailing = account.personalDailyLossLimitTrailing
            }
            .onChange(of: isTrailing) {
                Task {
                    let _ = await XClient.get(account.firm).setPersonalLimits(account.accountId, account.personalDailyProfitTarget, account.personalDailyProfitTargetAction, account.personalDailyLossLimit, account.personalDailyLossLimitAction, isTrailing)
                }
            }
            .onChange(of: account) {
                if isTrailing != account.personalDailyLossLimitTrailing {
                    isTrailing = account.personalDailyLossLimitTrailing
                }
            }
        }
        .interactiveDismissDisabled()
    }
}
