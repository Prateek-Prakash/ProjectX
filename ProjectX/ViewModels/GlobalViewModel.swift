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
    @AppStorage("delayTradeStats") var delayTradeStats: Bool = false
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
    @Published var mnqPrice: Double? = nil
    @Published var esPrice: Double? = nil
    @Published var mesPrice: Double? = nil
    @Published var gcPrice: Double? = nil
    @Published var mgcPrice: Double? = nil
    @Published var siPrice: Double? = nil
    @Published var silPrice: Double? = nil
    
    @Published var runUpPoints: Double? = nil
    @Published var runUpDollars: Double? = nil
    @Published var drawdownPoints: Double? = nil
    @Published var drawdownDollars: Double? = nil
    
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
            case .topstep:
                await signIn(firm, topstepUsername, topstepKey)
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
            try! await Task.sleep(for: .seconds(5))
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
        let searches = await XClient.get(firm).searchAccounts()
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
            let account = Account.fromDto(active, firm, type, tradable, positions)
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
    
    func calculateTradeStats(_ firm: Firm, _ trade: Trade) async {
        runUpPoints = nil
        runUpDollars = nil
        drawdownPoints = nil
        drawdownDollars = nil
        
        if delayTradeStats {
            try! await Task.sleep(for: .seconds(5))
        }
        
        // TODO: Calculate 5+ Hours
        // TODO: FUCKING SIMPLIFY THIS SHIT
        if trade.underFiveHours() {
            if let response = await XClient.get(firm).getBars(trade.contractId!, trade.createdAt, trade.exitedAt) {
                if !response.bars.isEmpty {
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
                    
                    if trade.positionSize < 0 {
                        // Long
                        runUpPoints = high - trade.entryPrice
                        drawdownPoints = trade.entryPrice - low
                        // TODO: Calculate Dollars
                    } else if trade.positionSize > 0 {
                        // Short
                        runUpPoints = low - trade.entryPrice
                        drawdownPoints = trade.entryPrice - high
                        // TODO: Calculate Dollars
                    }
                }
            }
        }
        
        if runUpPoints == nil { runUpPoints = -1 }
        if runUpDollars == nil { runUpDollars = -1 }
        if drawdownPoints == nil { drawdownPoints = -1 }
        if drawdownDollars == nil { drawdownDollars = -1 }
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
                    } else if id.contains("CON.F.US.MNQ") {
                        self.mnqPrice = price
                    } else if id.contains("CON.F.US.EP") {
                        self.esPrice = price
                    } else if id.contains("CON.F.US.MES") {
                        self.mesPrice = price
                    } else if id.contains("CON.F.US.GCE") {
                        self.gcPrice = price
                    } else if id.contains("CON.F.US.MGC") {
                        self.mgcPrice = price
                    } else if id.contains("CON.F.US.SIE") {
                        self.siPrice = price
                    } else if id.contains("CON.F.US.SIL") {
                        self.silPrice = price
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
        await invokeMarketSubscription("CON.F.US.EP.H26")
        await invokeMarketSubscription("CON.F.US.MES.H26")
        await invokeMarketSubscription("CON.F.US.GCE.J26")
        await invokeMarketSubscription("CON.F.US.MGC.J26")
        await invokeMarketSubscription("CON.F.US.SIE.H26")
        await invokeMarketSubscription("CON.F.US.SIL.H26")
    }
    
    func invokeMarketSubscription(_ contract: String) async {
        do {
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: contract)
        } catch {
            Helpers.debugLog("invokeMarketSubscriptions: \(error)")
        }
    }
}
