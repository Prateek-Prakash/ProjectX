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
    
    // AlphaFuturesX
    @AppStorage("alphaFuturesUsername") var alphaFuturesUsername: String = ""
    @AppStorage("alphaFuturesKey") var alphaFuturesKey: String = ""
    @AppStorage("alphaFuturesFunded") var alphaFuturesFunded: [Int] = []
    @AppStorage("alphaFuturesPractice") var alphaFuturesPractice: [Int] = []
    // LucidTradingX
    @AppStorage("lucidTradingUsername") var lucidTradingUsername: String = ""
    @AppStorage("lucidTradingKey") var lucidTradingKey: String = ""
    @AppStorage("lucidTradingFunded") var lucidTradingFunded: [Int] = []
    @AppStorage("lucidTradingPractice") var lucidTradingPractice: [Int] = []
    // TopstepX
    @AppStorage("topstepUsername") var topstepUsername: String = ""
    @AppStorage("topstepKey") var topstepKey: String = ""
    @AppStorage("topstepFunded") var topstepFunded: [Int] = []
    @AppStorage("topstepPractice") var topstepPractice: [Int] = []
    // TradeifyX
    @AppStorage("tradeifyUsername") var tradeifyUsername: String = ""
    @AppStorage("tradeifyKey") var tradeifyKey: String = ""
    @AppStorage("tradeifyFunded") var tradeifyFunded: [Int] = []
    @AppStorage("tradeifyPractice") var tradeifyPractice: [Int] = []
    
    // Notifications
    @AppStorage("pushNotifications") var pushNotifications: Bool = false
    @AppStorage("liveActivities") var liveActivities: Bool = false
    
    // Customization
    @AppStorage("showEvaluationAccounts") var showEvaluationAccounts: Bool = true
    @AppStorage("showFundedAccounts") var showFundedAccounts: Bool = true
    @AppStorage("showPracticeAccounts") var showPracticeAccounts: Bool = true
    @AppStorage("hideEmptyFirms") var hideEmptyFirms: Bool = true
    @AppStorage("hideLockedAccounts") var hideLockedAccounts: Bool = false
    @AppStorage("subtractStartingBalance") var subtractStartingBalance: Bool = true
    
    // Developer
    @AppStorage("nextMarketOpen") var nextMarketOpen: String = ""
    @AppStorage("nextMarketClose") var nextMarketClose: String = ""
    @AppStorage("priceStreaming") var priceStreaming: Bool = false
    @AppStorage("delayAuthentication") var delayAuthentication: Bool = false
    @AppStorage("delayLoadingTrades") var delayLoadingTrades: Bool = false
    @AppStorage("automaticRefresh") var automaticRefresh: Bool = true
    @AppStorage("automaticBackup") var automaticBackup: Bool = false
    @AppStorage("executeLockouts") var executeLockouts: Bool = true
    
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
                    await self.initMarketSignals(.topstep)
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
            case .alphaFutures:
                await signIn(firm, alphaFuturesUsername, alphaFuturesKey)
            case .lucidTrading:
                await signIn(firm, lucidTradingUsername, lucidTradingKey)
            case .topstep:
                await signIn(firm, topstepUsername, topstepKey)
            case .tradeify:
                await signIn(firm, tradeifyUsername, tradeifyKey)
            }
        } else {
            authenticatingStates[firm] = false
        }
    }
    
    func linkFirm(_ firm: Firm, _ username: String, _ key: String) async {
        switch firm {
        case .alphaFutures:
            if alphaFuturesUsername != username || alphaFuturesKey != key {
                alphaFuturesUsername = username
                alphaFuturesKey = key
                if isLinked(firm) {
                    await signIn(firm, username, key)
                } else {
                    await signOut(firm)
                }
            }
        case .lucidTrading:
            if lucidTradingUsername != username || lucidTradingKey != key {
                lucidTradingUsername = username
                lucidTradingKey = key
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
        case .tradeify:
            if tradeifyUsername != username || tradeifyKey != key {
                tradeifyUsername = username
                tradeifyKey = key
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
            case .alphaFutures:
                type = alphaFuturesFunded.contains(id) ? .funded : alphaFuturesPractice.contains(id) ? .practice : .evaluation
            case .lucidTrading:
                type = lucidTradingFunded.contains(id) ? .funded : lucidTradingPractice.contains(id) ? .practice : .evaluation
            case .topstep:
                type = topstepFunded.contains(id) ? .funded : topstepPractice.contains(id) ? .practice : .evaluation
            case .tradeify:
                type = tradeifyFunded.contains(id) ? .funded : tradeifyPractice.contains(id) ? .practice : .evaluation
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
            case .alphaFutures:
                alphaFuturesFunded.removeAll(where: { !ids.contains($0) })
                alphaFuturesPractice.removeAll(where: { !ids.contains($0) })
            case .lucidTrading:
                lucidTradingFunded.removeAll(where: { !ids.contains($0) })
                lucidTradingPractice.removeAll(where: { !ids.contains($0) })
            case .topstep:
                topstepFunded.removeAll(where: { !ids.contains($0) })
                topstepPractice.removeAll(where: { !ids.contains($0) })
            case .tradeify:
                tradeifyFunded.removeAll(where: { !ids.contains($0) })
                tradeifyPractice.removeAll(where: { !ids.contains($0) })
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
        case .alphaFutures:
            alphaFuturesFunded.removeAll()
            alphaFuturesPractice.removeAll()
        case .lucidTrading:
            lucidTradingFunded.removeAll()
            lucidTradingPractice.removeAll()
        case .topstep:
            topstepFunded.removeAll()
            topstepPractice.removeAll()
        case .tradeify:
            tradeifyFunded.removeAll()
            tradeifyPractice.removeAll()
        }
    }
    
    func isLinked(_ firm: Firm) -> Bool {
        switch firm {
        case .alphaFutures:
            return !alphaFuturesUsername.isEmpty && !alphaFuturesKey.isEmpty
        case .lucidTrading:
            return !lucidTradingUsername.isEmpty && !lucidTradingKey.isEmpty
        case .topstep:
            return !topstepUsername.isEmpty && !topstepKey.isEmpty
        case .tradeify:
            return !tradeifyUsername.isEmpty && !tradeifyKey.isEmpty
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
        case .alphaFutures:
            type == .funded ? alphaFuturesFunded.append(id) : alphaFuturesFunded.removeAll(where: { $0 == id })
            type == .practice ? alphaFuturesPractice.append(id) : alphaFuturesPractice.removeAll(where: { $0 == id })
        case .lucidTrading:
            type == .funded ? lucidTradingFunded.append(id) : lucidTradingFunded.removeAll(where: { $0 == id })
            type == .practice ? lucidTradingPractice.append(id) : lucidTradingPractice.removeAll(where: { $0 == id })
        case .topstep:
            type == .funded ? topstepFunded.append(id) : topstepFunded.removeAll(where: { $0 == id })
            type == .practice ? topstepPractice.append(id) : topstepPractice.removeAll(where: { $0 == id })
        case .tradeify:
            type == .funded ? tradeifyFunded.append(id) : tradeifyFunded.removeAll(where: { $0 == id })
            type == .practice ? tradeifyPractice.append(id) : tradeifyPractice.removeAll(where: { $0 == id })
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
        case .alphaFutures:
            usernameInput = alphaFuturesUsername
            keyInput = alphaFuturesKey
        case .lucidTrading:
            usernameInput = lucidTradingUsername
            keyInput = lucidTradingKey
        case .topstep:
            usernameInput = topstepUsername
            keyInput = topstepKey
        case .tradeify:
            usernameInput = tradeifyUsername
            keyInput = tradeifyKey
        }
    }
    
    func saveCredentials(_ firm: Firm) async {
        await linkFirm(firm, usernameInput, keyInput)
    }
    
    func isLocked(_ account: Account) -> Bool {
        let accounts = allAccounts.filter({ $0.firm == account.firm })
        let leader = accounts.first(where: { $0.isLeader })
        return !account.canTrade || (leader != nil && !leader!.canTrade && account.isFollower)
    }
    
    func lockAccount(_ account: Account, _ start: Date, _ end: Date) async {
        Helpers.debugLog("Start: \(start.asFractionalDateTime())")
        Helpers.debugLog("End: \(end.asFractionalDateTime())")
        if executeLockouts {
            await XClient.get(account.firm).lockAccount(account.accountId, account.userId, start, end)
        }
    }
    
    func flattenAccount(_ account: Account) async {
        let success = await XClient.get(account.firm).flattenAccount(account.accountId)
        Helpers.debugLog("Flatten: \(account.accountId) \(success ? "Success" : "Failed")")
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
    
    func initMarketSignals(_ firm: Firm) async {
        do {
            var options = HttpConnectionOptions()
            options.transport = .webSockets
            options.skipNegotiation = true
            options.accessTokenFactory = { return await XClient.get(firm).gatewayToken! }
            options.timeout = 10000
            options.logLevel = .information
            
            marketCtx = HubConnectionBuilder()
                .withUrl(url: XClient.get(firm).authMarketHubUrl, options: options)
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
            await invokeMarketSubscriptions()
            await marketCtx?.onReconnecting { _ in
                Helpers.debugLog("initMarketSignals: Disconnected")
            }
            await marketCtx?.onReconnected {
                Helpers.debugLog("initMarketSignals: Reconnected")
                await self.invokeMarketSubscriptions()
            }
        } catch {
            Helpers.debugLog("initMarketSignals: \(error)")
        }
    }
    
    func invokeMarketSubscriptions() async {
        do {
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.ENQ.H26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.MNQ.H26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.EP.H26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.MES.H26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.GCE.G26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.MGC.G26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.SIE.H26")
            try await marketCtx?.invoke(method: "SubscribeContractQuotes", arguments: "CON.F.US.SIL.H26")
        } catch {
            Helpers.debugLog("invokeMarketSubscriptions: \(error)")
        }
    }
}
