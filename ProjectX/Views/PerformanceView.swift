//
//  PerformanceView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import SwiftUI

struct PerformanceView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var showLockoutSheet: Bool = false
    @State var showDailyProfitTargetSheet: Bool = false
    @State var showDailyLossLimitSheet: Bool = false
    @State var isTrailing: Bool = false
    @State var autoBrackets: Bool = false
    @State var positionBrackets: Bool = true
    
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
                        VStack(spacing: 10) {
                            HStack(spacing: 10) {
                                Button {
                                    showLockoutSheet.toggle()
                                } label: {
                                    OriginCard(color: .red) {
                                        GroupBox {
                                            HStack {
                                                HStack {
                                                    Image(systemName: "lock")
                                                        .imageScale(.small)
                                                    Text("LOCKOUT")
                                                        .tracking(2)
                                                        .font(.system(size: 10, weight: .medium, design: .rounded))
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(.red)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                }
                                .buttonStyle(.plain)
                                .disabled(!account.canTrade || !globalVM.inTradingHours)
                                
                                Button {
                                    HapticViewModel.shared.successHaptic()
                                    Task {
                                        await globalVM.flattenAccount(account)
                                    }
                                } label: {
                                    OriginCard(color: .yellow) {
                                        GroupBox {
                                            HStack {
                                                HStack {
                                                    Image(systemName: "exclamationmark.octagon")
                                                        .imageScale(.small)
                                                    Text("FLATTEN")
                                                        .tracking(2)
                                                        .font(.system(size: 10, weight: .medium, design: .rounded))
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(.yellow)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                }
                                .buttonStyle(.plain)
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
                                        Text("RISK SETTINGS")
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
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        NavigationLink {
                                            SymbolBlocksView(account: account)
                                        }  label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Symbol Blocks")
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
                                }
                            }
                            
                            OriginCard {
                                VStack(spacing: 0) {
                                    OriginHeader {
                                        Text("BRACKETS")
                                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                            .tracking(2)
                                            .foregroundStyle(Color(.xHeaderText))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    VStack(spacing: 0) {
                                        Button {
                                            autoBrackets.toggle()
                                        } label: {
                                            GroupBox {
                                                HStack {
                                                    Text("Auto Brackets")
                                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                                    Spacer()
                                                    Toggle("", isOn: $autoBrackets)
                                                        .scaleEffect(0.6, anchor: .trailing)
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
                                    
                                    Button {
                                        positionBrackets.toggle()
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Position Brackets")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Toggle("", isOn: $positionBrackets)
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
                                                PositionTile(firm: account.firm, position: position)
                                                if account.positions.last != position {
                                                    Divider()
                                                        .frame(height: 1)
                                                        .overlay(Color(.xOutline))
                                                }
                                            }
                                        } else {
                                            ContentUnavailableView {
                                                Label("NO POSITIONS FOUND", systemImage: "exclamationmark.triangle")
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
                                        TradeHistoryView(firm: account.firm)
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
                                                TradeTile(firm: account.firm, trade: trade, tappable: true)
                                                if globalVM.accountTrades.last != trade {
                                                    Divider()
                                                        .frame(height: 1)
                                                        .overlay(Color(.xOutline))
                                                }
                                            }
                                        } else {
                                            ContentUnavailableView {
                                                Label("NO TRADES FOUND", systemImage: "exclamationmark.triangle")
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
                                                Label("NO DAILY STATS FOUND", systemImage: "exclamationmark.triangle")
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
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AnalyzerView()
                    } label: {
                        Image(systemName: "sparkles")
                            .imageScale(.small)
                            .increaseTapArea(by: 12)
                    }
                    .buttonStyle(.plain)
                    .disabled(globalVM.loadingTrades)
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .sheet(isPresented: $showLockoutSheet) {
                LockoutSheet(account: account)
            }
            .sheet(isPresented: $showDailyProfitTargetSheet) {
                DailyProfitTargetSheet(account: account)
            }
            .sheet(isPresented: $showDailyLossLimitSheet) {
                DailyLossLimitSheet(account: account)
            }
            .onAppear {
                isTrailing = account.personalDailyLossLimitTrailing
            }
            .onChange(of: isTrailing) {
                Task {
                    let _ = await XClient.get(account.firm).setPersonalLimits(account.accountId, account.personalDailyProfitTarget, account.personalDailyProfitTargetAction, account.personalDailyLossLimit, account.personalDailyLossLimitAction, isTrailing)
                }
            }
            .onAppear {
                autoBrackets = account.autoOcoBrackets
                positionBrackets = !autoBrackets
            }
            .onChange(of: autoBrackets) {
                positionBrackets = !autoBrackets
                Task {
                    let _ = await XClient.get(account.firm).setAutoBrackets(account.accountId, autoBrackets)
                }
            }
            .onChange(of: positionBrackets) {
                autoBrackets = !positionBrackets
                Task {
                    let _ = await XClient.get(account.firm).setAutoBrackets(account.accountId, !positionBrackets)
                }
            }
            .onChange(of: account) { old, new in
                if isTrailing != new.personalDailyLossLimitTrailing {
                    isTrailing = new.personalDailyLossLimitTrailing
                }
                
                if autoBrackets != new.autoOcoBrackets {
                    autoBrackets = new.autoOcoBrackets
                    positionBrackets = !autoBrackets
                }
                
                if old.realizedDayPnl != new.realizedDayPnl || old.positions.count != new.positions.count {
                    if globalVM.audioAlerts {
                        if old.positions.count < new.positions.count {
                            AudioViewModel.shared.speakText("ENTERED POSITION")
                        } else if old.positions.count > new.positions.count {
                            AudioViewModel.shared.speakText("EXITED POSITION")
                        }
                    }
                    
                    Task {
                        await globalVM.loadDailyStats(account)
                        await globalVM.loadTrades(account)
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
}
