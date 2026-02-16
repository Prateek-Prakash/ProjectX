//
//  GlobalViewModel.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/21/25.
//

import Combine
import Foundation
import SignalRClient
import SwiftUI

@MainActor
class GlobalViewModel: ObservableObject {
    static let shared = GlobalViewModel()
    
    // TheFuturesDeskX
    @AppStorage("theFuturesDeskUsername") var theFuturesDeskUsername: String = ""
    @AppStorage("theFuturesDeskKey") var theFuturesDeskKey: String = ""
    @AppStorage("theFuturesDeskFunded") var theFuturesDeskFunded: [Int] = []
    @AppStorage("theFuturesDeskPractice") var theFuturesDeskPractice: [Int] = []
    // TopstepX
    @AppStorage("topstepUsername") var topstepUsername: String = ""
    @AppStorage("topstepKey") var topstepKey: String = ""
    @AppStorage("topstepFunded") var topstepFunded: [Int] = []
    @AppStorage("topstepPractice") var topstepPractice: [Int] = []
    
    // Notifications
    @AppStorage("pushNotifications") var pushNotifications: Bool = false
    @AppStorage("liveActivities") var liveActivities: Bool = false
    @AppStorage("audioAlerts") var audioAlerts: Bool = false
    
    // Customization
    @AppStorage("showEvaluationAccounts") var showEvaluationAccounts: Bool = true
    @AppStorage("showFundedAccounts") var showFundedAccounts: Bool = true
    @AppStorage("showPracticeAccounts") var showPracticeAccounts: Bool = true
    @AppStorage("hideEmptyFirms") var hideEmptyFirms: Bool = true
    @AppStorage("hideLockedAccounts") var hideLockedAccounts: Bool = false
    @AppStorage("subtractStartingBalance") var subtractStartingBalance: Bool = true
    @AppStorage("glassSheets") var glassSheets: Bool = true
    
    // Developer
    @AppStorage("nextMarketOpen") var nextMarketOpen: String = ""
    @AppStorage("nextMarketClose") var nextMarketClose: String = ""
    @AppStorage("streamingSource") var streamingSource: Firm = .topstep
    @AppStorage("priceStreaming") var priceStreaming: Bool = false
    @AppStorage("delayAuthentication") var delayAuthentication: Bool = false
    @AppStorage("delayLoadingTrades") var delayLoadingTrades: Bool = false
    @AppStorage("delayTradeInfo") var delayTradeInfo: Bool = false
    @AppStorage("delayStatsInfo") var delayStatsInfo: Bool = false
    @AppStorage("delaySymbolBlocks") var delaySymbolBlocks: Bool = false
    @AppStorage("executeLockouts") var executeLockouts: Bool = true
    @AppStorage("blurBalances") var blurBalances: Bool = false
    
    @Published var authenticatingStates: [Firm:Bool] = [:]
    @Published var connectedStates: [Firm:Bool] = [:]
    
    @Published var inTradingHours: Bool = false
    @Published var refreshingData: Bool = false
    @Published var allAccounts: [Account] = []
    
    @Published var loadingTrades: Bool = false
    @Published var selectedAccount: Account? = nil
    @Published var accountDailyStats: [DailyStats] = []
    @Published var accountTrades: [Trade] = []
    
    @Published var usernameInput: String = ""
    @Published var keyInput: String = ""
    
    @Published var marketCtx: HubConnection?
    @Published var nqPrice: Double? = nil
    @Published var nqBid: Double? = nil
    @Published var nqAsk: Double? = nil
    @Published var mnqPrice: Double? = nil
    @Published var mnqBid: Double? = nil
    @Published var mnqAsk: Double? = nil
    
    @Published var allContracts: [Firm:[Contract]] = [
        .theFuturesDesk: [],
        .topstep: []
    ]
    
    @Published var loadingTradeInfo: Bool = false
    @Published var mfePoints: Double? = nil
    @Published var mfeDollars: Double? = nil
    @Published var maePoints: Double? = nil
    @Published var maeDollars: Double? = nil
    
    @Published var loadingStatsInfo: Bool = false
    @Published var statsMfe: Double? = nil
    @Published var statsMae: Double? = nil
    @Published var statsWinner: Double? = nil
    @Published var statsLoser: Double? = nil
    
    
    @Published var barData: [Firm:[String:BarResponseDTO]] = [
        .theFuturesDesk: [:],
        .topstep: [:]
    ]
    
    @Published var mfePointsMap: [Firm:[String:Double]] = [
        .theFuturesDesk: [:],
        .topstep: [:]
    ]
    @Published var mfeDollarsMap: [Firm:[String:Double]] = [
        .theFuturesDesk: [:],
        .topstep: [:]
    ]
    @Published var maePointsMap: [Firm:[String:Double]] = [
        .theFuturesDesk: [:],
        .topstep: [:]
    ]
    @Published var maeDollarsMap: [Firm:[String:Double]] = [
        .theFuturesDesk: [:],
        .topstep: [:]
    ]
    
    @Published var loadingSymbolBlocks: Bool = false
    @Published var symbolBlocks: [SymbolBlock] = []
    
    @Published var isInitialized = false
    let continuousClock = ContinuousClock()
    
    init() {
        Task {
            let initTime = await self.continuousClock.measure {
                await withTaskGroup(of: Void.self) { group in
                    for firm in Firm.allCases {
                        group.addTask {
                            await self.initFirm(firm)
                        }
                    }
                }
                
                if let marketStatus = await XClient.topstep.getMarketStatus() {
                    self.nextMarketOpen = marketStatus.nextOpen
                    self.nextMarketClose = marketStatus.close
                }
                
                if self.priceStreaming {
                    await self.initMarketSignals()
                }
            }
            
            Helpers.debugLog("initTime: \(initTime.description.split(separator: " ")[0])")
            self.isInitialized = true
        }
    }
    
    func initFirm(_ firm: Firm) async {
        authenticatingStates[firm] = true
        connectedStates[firm] = false
        if isLinked(firm) {
            switch firm {
            case .theFuturesDesk:
                await signIn(firm, theFuturesDeskUsername, theFuturesDeskKey)
                await loadContracts(firm)
            case .topstep:
                await signIn(firm, topstepUsername, topstepKey)
                await loadContracts(firm)
            }
        } else {
            authenticatingStates[firm] = false
        }
    }
    
    func linkFirm(_ firm: Firm, _ username: String, _ key: String) async {
        switch firm {
        case .theFuturesDesk:
            if theFuturesDeskUsername != username || theFuturesDeskKey != key {
                theFuturesDeskUsername = username
                theFuturesDeskKey = key
                if isLinked(firm) {
                    await signIn(firm, username, key)
                } else {
                    await signOut(firm)
                }
            }
        case .topstep:
            if topstepUsername != username || topstepKey != key {
                topstepUsername = username
                topstepKey = key
                if isLinked(firm) {
                    await signIn(firm, username, key)
                } else {
                    await signOut(firm)
                }
            }
        }
    }
    
    func signIn(_ firm: Firm, _ username: String, _ key: String) async {
        authenticatingStates[firm] = true
        if delayAuthentication {
            try! await Task.sleep(for: .seconds(3))
        }
        let isConnected = await XClient.get(firm).signIn(username, key)
        if isConnected {
            await loadAccounts(firm)
        }
        connectedStates[firm] = isConnected
        authenticatingStates[firm] = false
    }
    
    func signOut(_ firm: Firm) async {
        unloadAccounts(firm)
        connectedStates[firm] = false
        _ = await XClient.get(firm).signOut()
    }
    
    func loadAccounts(_ firm: Firm) async {
        let dtos = await XClient.get(firm).getAccounts()
        let searches = await XClient.get(firm).searchAccounts() // Identifying Firm DLLs
        let actives = dtos.filter({ !$0.ineligible })
        var accounts: [Account] = []
        for active in actives {
            let id = active.accountId
            var type = AccountType.evaluation
            let tradable = searches?.accounts.filter({ $0.id == id }).first?.canTrade ?? true
            switch firm {
            case .theFuturesDesk:
                type = theFuturesDeskFunded.contains(id) ? .funded : theFuturesDeskPractice.contains(id) ? .practice : .evaluation
            case .topstep:
                type = topstepFunded.contains(id) ? .funded : topstepPractice.contains(id) ? .practice : .evaluation
            }
            let positions: [Position] = await XClient.get(firm).getPositions(id)?.positions.map({ Position.fromDto($0) }) ?? []
            let orders: [Order] = await XClient.get(firm).getOrders(id)?.orders.map({ Order.fromDto($0) }).sorted(by: { $0.id < $1.id }) ?? []
            let account = Account.fromDto(active, firm, type, tradable, positions, orders)
            accounts.append(account)
        }
        
        if allAccounts.isEmpty {
            allAccounts.append(contentsOf: accounts)
        } else {
            for account in accounts {
                let index = allAccounts.firstIndex(where: { $0.firm == firm && $0.accountId == account.accountId })
                if let index = index {
                    allAccounts[index] = account
                } else {
                    allAccounts.append(account)
                }
            }
            let ids = accounts.map({ $0.accountId })
            allAccounts.removeAll(where: { $0.firm == firm && !ids.contains($0.accountId) })
        }
    }
    
    func loadContracts(_ firm: Firm) async {
        let dtos = await XClient.get(firm).getContracts()
        var contracts: [Contract] = []
        for dto in dtos {
            let contract = Contract.fromDto(dto)
            contracts.append(contract)
        }
        allContracts[firm] = contracts.sorted(by: { $0.productName < $1.productName })
    }
    
    func clearOldIds() {
        for firm in Firm.allCases {
            let accounts = allAccounts.filter({ $0.firm == firm })
            let ids = accounts.map({ $0.accountId })
            switch firm {
            case .theFuturesDesk:
                theFuturesDeskFunded.removeAll(where: { !ids.contains($0) })
                theFuturesDeskPractice.removeAll(where: { !ids.contains($0) })
            case .topstep:
                topstepFunded.removeAll(where: { !ids.contains($0) })
                topstepPractice.removeAll(where: { !ids.contains($0) })
            }
        }
    }
    
    func refreshData() async {
        if !refreshingData {
            refreshingData = true
            Helpers.debugLog("refreshData")
            await withTaskGroup(of: Void.self) { group in
                for firm in Firm.allCases {
                    if isConnected(firm) {
                        group.addTask {
                            await self.loadAccounts(firm)
                        }
                    }
                }
            }
            refreshingData = false
        }
    }
    
    func unloadAccounts(_ firm: Firm) {
        allAccounts.removeAll(where: { $0.firm == firm })
        // Clear Saved IDs
        switch firm {
        case .theFuturesDesk:
            theFuturesDeskFunded.removeAll()
            theFuturesDeskPractice.removeAll()
        case .topstep:
            topstepFunded.removeAll()
            topstepPractice.removeAll()
        }
    }
    
    func isLinked(_ firm: Firm) -> Bool {
        switch firm {
        case .theFuturesDesk:
            return !theFuturesDeskUsername.isEmpty && !theFuturesDeskKey.isEmpty
        case .topstep:
            return !topstepUsername.isEmpty && !topstepKey.isEmpty
        }
    }
    
    func isAuthenticating(_ firm: Firm) -> Bool {
        return authenticatingStates[firm] ?? true
    }
    
    func isConnected(_ firm: Firm) -> Bool {
        return connectedStates[firm] ?? false
    }
    
    func rotateAccountType(_ account: Account) {
        let firm = account.firm
        let id = account.accountId
        let index = allAccounts.firstIndex(where: { $0.firm == firm && $0.accountId == id })!
        switch allAccounts[index].accountType {
        case .evaluation:
            allAccounts[index].accountType = .funded
        case .funded:
            allAccounts[index].accountType = .practice
        case .practice:
            allAccounts[index].accountType = .evaluation
        }
        persistAccountType(firm, id, allAccounts[index].accountType)
    }
    
    func persistAccountType(_ firm: Firm, _ id: Int, _ type: AccountType) {
        switch firm {
        case .theFuturesDesk:
            type == .funded ? theFuturesDeskFunded.append(id) : theFuturesDeskFunded.removeAll(where: { $0 == id })
            type == .practice ? theFuturesDeskPractice.append(id) : theFuturesDeskPractice.removeAll(where: { $0 == id })
        case .topstep:
            type == .funded ? topstepFunded.append(id) : topstepFunded.removeAll(where: { $0 == id })
            type == .practice ? topstepPractice.append(id) : topstepPractice.removeAll(where: { $0 == id })
        }
    }
    
    func loadDailyStats(_ account: Account) async {
        Helpers.debugLog("loadDailyStats")
        let dtos = await XClient.get(account.firm).getDailyStats(account.accountId)
        accountDailyStats = dtos.map({ DailyStats.fromDto($0) }).sorted(by: { $0.tradeDate.toDateTime() > $1.tradeDate.toDateTime() })
    }
    
    func loadTrades(_ account: Account) async {
        Helpers.debugLog("loadTrades")
        let dtos = await XClient.get(account.firm).getTrades(account.accountId)
        accountTrades = dtos.map({ Trade.fromDto($0) }).sorted(by: { $0.createdAt.toFractionalDateTime() > $1.createdAt.toFractionalDateTime() })
    }
    
    func loadCredentials(_ firm: Firm)  {
        switch firm {
        case .theFuturesDesk:
            usernameInput = theFuturesDeskUsername
            keyInput = theFuturesDeskKey
        case .topstep:
            usernameInput = topstepUsername
            keyInput = topstepKey
        }
    }
    
    func saveCredentials(_ firm: Firm) async {
        await linkFirm(firm, usernameInput, keyInput)
    }
    
    func isLocked(_ account: Account) -> Bool {
        let accounts = allAccounts.filter({ $0.firm == account.firm })
        let leader = accounts.first(where: { $0.isLeader })
        let blocked = account.personalDailyProfitTarget != nil && account.realizedDayPnl >= Double(account.personalDailyProfitTarget!) && account.personalDailyProfitTargetAction == 1
        return !account.canTrade || (leader != nil && !leader!.canTrade && account.isFollower) || blocked
    }
    
    func lockAccount(_ account: Account, _ start: Date, _ end: Date) async {
        Helpers.debugLog("Start: \(start.asFractionalDateTime())")
        Helpers.debugLog("End: \(end.asFractionalDateTime())")
        if executeLockouts {
            HapticViewModel.shared.successHaptic()
            await XClient.get(account.firm).lockAccount(account.accountId, account.userId, start, end)
        }
    }
    
    func flattenAccount(_ account: Account) async {
        let success = await XClient.get(account.firm).flattenAccount(account.accountId)
        Helpers.debugLog("Flatten: \(account.accountId) \(success ? "Success" : "Failed")")
    }
    
    // MARK: Caclulate Stats
    
    func calculateTradeInfo(_ firm: Firm, _ trade: Trade) async {
        loadingTradeInfo = true
        
        mfePoints = nil
        mfeDollars = nil
        maePoints = nil
        maeDollars = nil
        
        if delayTradeInfo {
            try! await Task.sleep(for: .seconds(3))
        }
        
        // TODO: Calculate 5+ Hours
        // --
        // TODO: Tick Data
        // --
        // TODO: MFE: Long = (Highest) Bid - Entry
        // TODO: MFE: Short = Entry - (Lowest) Ask
        // --
        // TODO: MAE: Long = Entry - (Lowest) Bid
        // TODO: MAE: Short = (Highest) Ask - Entry
        if trade.underFiveHours() {
            if mfePointsMap[firm]![trade.ref] != nil && mfeDollarsMap[firm]![trade.ref] != nil &&  maePointsMap[firm]![trade.ref] != nil && maeDollarsMap[firm]![trade.ref] != nil {
                Helpers.debugLog("\(trade.ref): USING CACHED TRADE - calculateTradeStats")
                mfePoints = mfePointsMap[selectedAccount!.firm]![trade.ref]
                mfeDollars = mfeDollarsMap[selectedAccount!.firm]![trade.ref]
                maePoints = maePointsMap[selectedAccount!.firm]![trade.ref]
                maeDollars = maeDollarsMap[selectedAccount!.firm]![trade.ref]
            } else {
                let start = trade.createdAt // TODO: Floor
                let end = trade.exitedAt // TODO: Ceiling
                
                if let response = await XClient.get(firm).getBars(trade.contractId!, start, end, .second) {
                    if !response.bars.isEmpty {
                        barData[firm]![trade.ref] = response
                        
                        var high = trade.entryPrice
                        var low = trade.entryPrice
                        for bar in response.bars {
                            if (bar.h > high) {
                                high = bar.h
                            }
                            if (bar.l < low) {
                                low = bar.l
                            }
                        }
                        
                        if trade.positionSize != 0 {
                            // Long: positionSize < 0
                            // Short: positionSize > 0
                            
                            mfePoints = trade.positionSize < 0 ? high - trade.entryPrice : trade.entryPrice - low
                            maePoints = trade.positionSize < 0 ? low - trade.entryPrice : trade.entryPrice - high
                            
                            let points = abs(trade.exitPrice - trade.entryPrice)
                            if trade.pnL < 0.0 {
                                if abs(points) > abs(maePoints!) {
                                    maePoints = abs(points)
                                }
                            } else {
                                if abs(points) > abs(mfePoints!) {
                                    mfePoints = abs(points)
                                }
                            }
                            
                            mfePointsMap[firm]![trade.ref] = mfePoints
                            maePointsMap[firm]![trade.ref] = maePoints
                            
                            if let contract = allContracts[firm]?.first(where: { $0.productId == trade.symbolId }) {
                                mfeDollars = mfePoints! / contract.tickSize * contract.tickValue * Double(abs(trade.positionSize))
                                maeDollars = maePoints! / contract.tickSize * contract.tickValue * Double(abs(trade.positionSize))
                                
                                if trade.pnL < 0.0 {
                                    if abs(trade.pnL) > abs(maeDollars!) {
                                        maeDollars = abs(trade.pnL)
                                    }
                                } else {
                                    if abs(trade.pnL) > abs(mfeDollars!) {
                                        mfeDollars = abs(trade.pnL)
                                    }
                                }
                                
                                mfeDollarsMap[firm]![trade.ref] = mfeDollars
                                maeDollarsMap[firm]![trade.ref] = maeDollars
                                
                                Helpers.debugLog("\(trade.ref): tickSize: \(contract.tickSize)")
                                Helpers.debugLog("\(trade.ref): tickValue: \(contract.tickValue)")
                                Helpers.debugLog("\(trade.ref): mfePoints: \(mfePoints!)")
                                Helpers.debugLog("\(trade.ref): mfeDollars: \(mfeDollars!)")
                                Helpers.debugLog("\(trade.ref): maePoints: \(maePoints!)")
                                Helpers.debugLog("\(trade.ref): maeDollars: \(maeDollars!)")
                            }
                        }
                    }
                }
            }
        }
        
        loadingTradeInfo = false
    }
    
    // Might Be Off Sometimes Until Tick Data Above
    func calculateStatsInfo(_ day: String) async {
        loadingStatsInfo = true
        
        statsMfe = nil
        statsMae = nil
        statsWinner = nil
        statsLoser = nil
        
        if delayStatsInfo {
            try! await Task.sleep(for: .seconds(3))
        }
        
        var mfeStreak: Bool = false
        var mfeRunning: Double = 0.0
        var maeStreak: Bool = false
        var maeRunning: Double = 0.0
        
        for trade in accountTrades.filter({ $0.tradeDay == day }).reversed() {
            if mfeDollarsMap[selectedAccount!.firm]![trade.ref] != nil && maeDollarsMap[selectedAccount!.firm]![trade.ref] != nil {
                Helpers.debugLog("\(trade.ref): USING CACHED TRADE - calculateDailyStatsInfo")
                mfeDollars = mfeDollarsMap[selectedAccount!.firm]![trade.ref]
                maeDollars = maeDollarsMap[selectedAccount!.firm]![trade.ref]
            } else {
                // TODO: Handle Rate Limit
                await calculateTradeInfo(selectedAccount!.firm, trade)
            }
            
            Helpers.debugLog("P&L: \(trade.pnL)")
            Helpers.debugLog("MFE: \(mfeDollars ?? 0.0)")
            Helpers.debugLog("MAE: \(maeDollars ?? 0.0)")
            
            // MFE
            if mfeDollars != nil && abs(mfeDollars!) >= 0.0 {
                mfeRunning = mfeRunning + abs(mfeDollars!)
            } else {
                // TODO: Probably Rate Limit
                // TODO: Display Alert + Exit Calculation || Delay + Retry
                Helpers.debugLog("\(trade.ref): SOMETHING WENT WRONG WITH MFE")
            }
            
            // MAE
            if maeDollars != nil && abs(maeDollars!) >= 0.0 {
                maeRunning = maeRunning + abs(maeDollars!)
            } else {
                // TODO: Probably Rate Limit
                // TODO: Display Alert + Exit Calculation || Delay + Retry
                Helpers.debugLog("\(trade.ref): SOMETHING WENT WRONG WITH MAE")
            }
            
            if trade.pnL >= 0.0 {
                // Winning Trade
                mfeStreak = true
                maeStreak = false
            } else {
                // Losing tradee
                mfeStreak = false
                maeStreak = true
            }
            
            // MFE
            if statsMfe == nil {
                statsMfe = mfeRunning
            } else {
                statsMfe! < mfeRunning ? (statsMfe = mfeRunning) : ()
            }
            !mfeStreak ? (mfeRunning = 0.0) : ()
            
            // MAE
            if statsMae == nil {
                statsMae = maeRunning
            } else {
                statsMae! < maeRunning ? (statsMae = maeRunning) : ()
            }
            !maeStreak ? (maeRunning = 0.0) : ()
            
            // Largest Winner
            if statsWinner == nil {
                statsWinner = trade.pnL
            } else {
                statsWinner! < trade.pnL ? (statsWinner = trade.pnL) : ()
            }
            
            // Largest Loser
            if statsLoser == nil {
                statsLoser = trade.pnL
            } else {
                statsLoser! > trade.pnL ? (statsLoser = trade.pnL) : ()
            }
        }
        
        statsMfe != nil ? (statsMfe = abs(statsMfe!)) : ()
        statsMae != nil ? (statsMae = abs(statsMae!) * -1) : ()
        
        loadingStatsInfo = false
    }
    
    func exportTrade(_ trade: Trade) -> String {
        let mfeDollars = mfeDollarsMap[selectedAccount!.firm]![trade.ref] != nil ? abs(mfeDollarsMap[selectedAccount!.firm]![trade.ref]!).asCurrency() : nil
        let mfe = mfeDollars != nil ? Double(mfeDollars!.replacingOccurrences(of: "$", with: "")) : nil
        let maeDollar = maeDollarsMap[selectedAccount!.firm]![trade.ref] != nil ? (-1 * abs(maeDollarsMap[selectedAccount!.firm]![trade.ref]!)).asCurrency() : nil
        let mae = maeDollar != nil ? Double(maeDollar!.replacingOccurrences(of: "$", with: "")) : nil
        let export = TradeExport(
            id: trade.id,
            tradeDate: trade.tradeDay,
            side: trade.positionSize < 0 ? "Long" : "Short",
            ticker: getTickerId(selectedAccount!.firm, trade.symbolId),
            size: abs(trade.positionSize),
            pnl: trade.pnL,
            fees: -1 * trade.fees,
            mfe: mfe,
            mae: mae,
            entryPrice: trade.entryPrice,
            exitPrice: trade.exitPrice,
            entryAt: trade.createdAt,
            exitAt: trade.exitedAt,
            duration: trade.tradeDurationDisplay,
            barData: barData[selectedAccount!.firm]![trade.ref]
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try! encoder.encode(export)
        let json = String(data: data, encoding: .utf8)!
        return json
    }
    
    func exportTrades(for day: String) -> String {
        let trades: [TradeExport] = accountTrades.filter({ $0.tradeDay == day }).reversed().map({
            let mfeDollars = mfeDollarsMap[selectedAccount!.firm]![$0.ref] != nil ? abs(mfeDollarsMap[selectedAccount!.firm]![$0.ref]!).asCurrency() : nil
            let mfe = mfeDollars != nil ? Double(mfeDollars!.replacingOccurrences(of: "$", with: "")) : nil
            let maeDollars = maeDollarsMap[selectedAccount!.firm]![$0.ref] != nil ? (-1 * abs(maeDollarsMap[selectedAccount!.firm]![$0.ref]!)).asCurrency() : nil
            let mae = maeDollars != nil ? Double(maeDollars!.replacingOccurrences(of: "$", with: "")) : nil
            return TradeExport(
                id: $0.id,
                tradeDate: $0.tradeDay,
                side: $0.positionSize < 0 ? "Long" : "Short",
                ticker: getTickerId(selectedAccount!.firm, $0.symbolId),
                size: abs($0.positionSize),
                pnl: $0.pnL,
                fees: -1 * $0.fees,
                mfe: mfe,
                mae: mae,
                entryPrice: $0.entryPrice,
                exitPrice: $0.exitPrice,
                entryAt: $0.createdAt,
                exitAt: $0.exitedAt,
                duration: $0.tradeDurationDisplay,
                barData: barData[selectedAccount!.firm]![$0.ref]
            )
        })
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try! encoder.encode(trades)
        let json = String(data: data, encoding: .utf8)!
        return json
    }
    
    // MARK: Symbol Blocks
    
    func loadSymbolBlocks() async {
        loadingSymbolBlocks = true
        
        if delaySymbolBlocks {
            try! await Task.sleep(for: .seconds(3))
        }
        
        symbolBlocks.removeAll()
        let dtos = await XClient.get(selectedAccount!.firm).getSymbolBlocks(selectedAccount!.accountId)
        symbolBlocks = dtos.map({ SymbolBlock.fromDto($0) }).sorted(by: { $0.symbolId < $1.symbolId })
        
        loadingSymbolBlocks = false
    }
    
    // MARK: Contract Helpers
    
    func getContract(_ id: String) -> Contract? {
        return allContracts[selectedAccount!.firm]?.first(where: { $0.productId == id })
    }
    
    func getTickerId(_ firm: Firm, _ id: String) -> String {
        if let contract = allContracts[firm]?.first(where: { $0.productId == id }) {
            return contract.productName.replacingOccurrences(of: "/", with: "")
        }
        return "--"
    }
    
    func getTickerDigits(_ firm: Firm, _ id: String) -> Int {
        let ticker = getTickerId(firm, id)
        if ticker != "--" {
            if let contract = allContracts[firm]?.first(where: { $0.productId == id }) {
                return contract.decimalPlaces
            }
        }
        return 7 // Largest Decimal (Japanese Yen)
    }
    
    // MARK: Market Status
    
    func isMarketClosed() -> Bool {
        guard let zone = TimeZone(identifier: "America/New_York") else {
            return false
        }
        
        var calendar = Calendar.current
        calendar.timeZone = zone
        
        let components = calendar.dateComponents([.weekday, .hour], from: Date.now)
        
        guard let weekday = components.weekday, let hour = components.hour else {
            return false
        }
        
        if weekday == 6 && hour >= 17 { return true }
        if weekday == 7 { return true }
        if weekday == 1 && hour < 18 { return true }
        if hour == 17 { return true }
        
        return false
    }
    
    // MARK: SignalR Stuff
    
    func initMarketSignals() async {
        do {
            var options = HttpConnectionOptions()
            options.transport = .webSockets
            options.skipNegotiation = true
            options.accessTokenFactory = { return await XClient.get(self.streamingSource).gatewayToken! }
            options.timeout = 10000
            options.logLevel = .information
            
            marketCtx = HubConnectionBuilder()
                .withUrl(url: XClient.get(streamingSource).authMarketHubUrl, options: options)
                .withAutomaticReconnect(retryDelays: [1, 1, 1, 1, 1])
                .build()
            
            await marketCtx?.on("GatewayQuote") { (id: String, quote: QuoteDTO) in
                if let price = quote.lastPrice {
                    Helpers.debugLog("\(id): \(price)")
                    if id.contains("CON.F.US.ENQ") {
                        self.nqPrice = price
                        self.nqBid = quote.bestBid
                        self.nqAsk = quote.bestAsk
                    } else if id.contains("CON.F.US.MNQ") {
                        self.mnqPrice = price
                        self.mnqBid = quote.bestBid
                        self.mnqAsk = quote.bestAsk
                    }
                }
            }
            
            try await marketCtx?.start()
            await invokeWatchlistSubscriptions()
            await marketCtx?.onReconnecting { _ in
                Helpers.debugLog("initMarketSignals: Disconnected")
            }
            await marketCtx?.onReconnected {
                Helpers.debugLog("initMarketSignals: Reconnected")
                await self.invokeWatchlistSubscriptions()
            }
        } catch {
            Helpers.debugLog("initMarketSignals: \(error)")
        }
    }
    
    func invokeWatchlistSubscriptions() async {
        await invokeMarketSubscription("CON.F.US.ENQ.H26")
        await invokeMarketSubscription("CON.F.US.MNQ.H26")
    }
    
    func invokeMarketSubscription(_ contract: String) async {
        do {
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: contract)
        } catch {
            Helpers.debugLog("invokeMarketSubscriptions: \(error)")
        }
    }
}
