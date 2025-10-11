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
    // AquaFuturesX
    @AppStorage("aquaFuturesUsername") var aquaFuturesUsername: String = ""
    @AppStorage("aquaFuturesKey") var aquaFuturesKey: String = ""
    @AppStorage("aquaFuturesFunded") var aquaFuturesFunded: [Int] = []
    @AppStorage("aquaFuturesPractice") var aquaFuturesPractice: [Int] = []
    // FundingFuturesX
    @AppStorage("fundingFuturesUsername") var fundingFuturesUsername: String = ""
    @AppStorage("fundingFuturesKey") var fundingFuturesKey: String = ""
    @AppStorage("fundingFuturesFunded") var fundingFuturesFunded: [Int] = []
    @AppStorage("fundingFuturesPractice") var fundingFuturesPractice: [Int] = []
    // HolaPrimeX
    @AppStorage("holaPrimeUsername") var holaPrimeUsername: String = ""
    @AppStorage("holaPrimeKey") var holaPrimeKey: String = ""
    @AppStorage("holaPrimeFunded") var holaPrimeFunded: [Int] = []
    @AppStorage("holaPrimePractice") var holaPrimePractice: [Int] = []
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
    @AppStorage("hideEmptyFirms") var hideEmptyFirms: Bool = false
    @AppStorage("hideLockedAccounts") var hideLockedAccounts: Bool = false
    @AppStorage("subtractStartingBalance") var subtractStartingBalance: Bool = false
    
    // Developer
    @AppStorage("automaticRefresh") var automaticRefresh: Bool = false
    @AppStorage("delayAuthentication") var delayAuthentication: Bool = false
    @AppStorage("delayLoadingTrades") var delayLoadingTrades: Bool = false
    
    @Published var authenticatingStates: [Firm:Bool] = [:]
    @Published var connectedStates: [Firm:Bool] = [:]
    
    @Published var refreshingData: Bool = false
    @Published var allAccounts: [Account] = []
    
    @Published var loadingTrades: Bool = false
    @Published var selectedAccount: Account? = nil
    @Published var accountTrades: [Trade] = []
    
    @Published var usernameInput: String = ""
    @Published var keyInput: String = ""
    
    @Published var userCtx: HubConnection?
    
    @Published var isInitialized = false
    let continuousClock = ContinuousClock()
    
    init() {
        Task {
            let initTime = await continuousClock.measure {
                await withTaskGroup(of: Void.self) { group in
                    for firm in Firm.allCases {
                        group.addTask {
                            await self.initFirm(firm)
                        }
                    }
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
            case .aquaFutures:
                await signIn(firm, aquaFuturesUsername, aquaFuturesKey)
            case .fundingFutures:
                await signIn(firm, fundingFuturesUsername, fundingFuturesKey)
            case .holaPrime:
                await signIn(firm, holaPrimeUsername, holaPrimeKey)
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
        case .aquaFutures:
            if aquaFuturesUsername != username || aquaFuturesKey != key {
                aquaFuturesUsername = username
                aquaFuturesKey = key
                if isLinked(firm) {
                    await signIn(firm, username, key)
                } else {
                    await signOut(firm)
                }
            }
        case .fundingFutures:
            if fundingFuturesUsername != username || fundingFuturesKey != key {
                fundingFuturesUsername = username
                fundingFuturesKey = key
                if isLinked(firm) {
                    await signIn(firm, username, key)
                } else {
                    await signOut(firm)
                }
            }
        case .holaPrime:
            if holaPrimeUsername != username || holaPrimeKey != key {
                holaPrimeUsername = username
                holaPrimeKey = key
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
        let accounts: [Account] = dtos.filter({ !$0.ineligible }).map({
            let id = $0.accountId
            var type = AccountType.evaluation
            switch firm {
            case .alphaFutures:
                type = alphaFuturesFunded.contains(id) ? .funded : alphaFuturesPractice.contains(id) ? .practice : .evaluation
            case .aquaFutures:
                type = aquaFuturesFunded.contains(id) ? .funded : aquaFuturesPractice.contains(id) ? .practice : .evaluation
            case .fundingFutures:
                type = fundingFuturesFunded.contains(id) ? .funded : fundingFuturesPractice.contains(id) ? .practice : .evaluation
            case .holaPrime:
                type = holaPrimeFunded.contains(id) ? .funded : holaPrimePractice.contains(id) ? .practice : .evaluation
            case .lucidTrading:
                type = lucidTradingFunded.contains(id) ? .funded : lucidTradingPractice.contains(id) ? .practice : .evaluation
            case .topstep:
                type = topstepFunded.contains(id) ? .funded : topstepPractice.contains(id) ? .practice : .evaluation
            case .tradeify:
                type = tradeifyFunded.contains(id) ? .funded : tradeifyPractice.contains(id) ? .practice : .evaluation
            }
            return Account.fromDto($0, firm, type)
        })
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
            case .aquaFutures:
                aquaFuturesFunded.removeAll(where: { !ids.contains($0) })
                aquaFuturesPractice.removeAll(where: { !ids.contains($0) })
            case .fundingFutures:
                fundingFuturesFunded.removeAll(where: { !ids.contains($0) })
                fundingFuturesPractice.removeAll(where: { !ids.contains($0) })
            case .holaPrime:
                holaPrimeFunded.removeAll(where: { !ids.contains($0) })
                holaPrimePractice.removeAll(where: { !ids.contains($0) })
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
            Helpers.debugLog("refreshData: Refreshing Accounts")
            await withTaskGroup(of: Void.self) { group in
                for firm in Firm.allCases {
                    if isConnected(firm) {
                        group.addTask {
                            await self.loadAccounts(firm)
                        }
                    }
                }
            }
            if let selectedAccount {
                Helpers.debugLog("refreshData: Refreshing Trades")
                await loadTrades(selectedAccount)
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
        case .aquaFutures:
            aquaFuturesFunded.removeAll()
            aquaFuturesPractice.removeAll()
        case .fundingFutures:
            fundingFuturesFunded.removeAll()
            fundingFuturesPractice.removeAll()
        case .holaPrime:
            holaPrimeFunded.removeAll()
            holaPrimePractice.removeAll()
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
        case .aquaFutures:
            return !aquaFuturesUsername.isEmpty && !aquaFuturesKey.isEmpty
        case .fundingFutures:
            return !fundingFuturesUsername.isEmpty && !fundingFuturesKey.isEmpty
        case .holaPrime:
            return !holaPrimeUsername.isEmpty && !holaPrimeKey.isEmpty
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
        case .aquaFutures:
            type == .funded ? aquaFuturesFunded.append(id) : aquaFuturesFunded.removeAll(where: { $0 == id })
            type == .practice ? aquaFuturesPractice.append(id) : aquaFuturesPractice.removeAll(where: { $0 == id })
        case .fundingFutures:
            type == .funded ? fundingFuturesFunded.append(id) : fundingFuturesFunded.removeAll(where: { $0 == id })
            type == .practice ? fundingFuturesPractice.append(id) : fundingFuturesPractice.removeAll(where: { $0 == id })
        case .holaPrime:
            type == .funded ? holaPrimeFunded.append(id) : holaPrimeFunded.removeAll(where: { $0 == id })
            type == .practice ? holaPrimePractice.append(id) : holaPrimePractice.removeAll(where: { $0 == id })
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
    
    func loadTrades(_ account: Account) async {
        let dtos = await XClient.get(account.firm).getTrades(account.accountId)
        accountTrades = dtos.map({ Trade.fromDto($0) }).sorted(by: { $0.createdAt.toDateTime() > $1.createdAt.toDateTime() })
            
    }
    
    func loadCredentials(_ firm: Firm)  {
        switch firm {
        case .alphaFutures:
            usernameInput = alphaFuturesUsername
            keyInput = alphaFuturesKey
        case .aquaFutures:
            usernameInput = aquaFuturesUsername
            keyInput = aquaFuturesKey
        case .fundingFutures:
            usernameInput = fundingFuturesUsername
            keyInput = fundingFuturesKey
        case .holaPrime:
            usernameInput = holaPrimeUsername
            keyInput = holaPrimeKey
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
    
    func isLocked(_ firm: Firm, _ account: Account) -> Bool {
        let accounts = allAccounts.filter({ $0.firm == firm })
        let leader = accounts.first(where: { $0.isLeader })
        return account.lockoutReason != nil || (leader != nil && leader!.lockoutReason != nil && account.isFollower)
    }
    
    // MARK: SignalR Stuff
    
    func initSignals(_ firm: Firm) async {
        do {
            var options = HttpConnectionOptions()
            options.transport = .webSockets
            options.skipNegotiation = true
            options.accessTokenFactory = { return await XClient.get(firm).gatewayToken! }
            options.timeout = 10000
            options.logLevel = .information
            
            userCtx = HubConnectionBuilder()
                .withUrl(url: XClient.get(firm).authUserHubUrl, options: options)
                .withAutomaticReconnect(retryDelays: [1, 1, 1, 1, 1])
                .build()
            
            await userCtx?.on("GatewayUserAccount") { (data: String) in
                Helpers.debugLog("initSignals: GatewayUserAccount")
            }
            await userCtx?.on("GatewayUserPosition") { (data: String) in
                Helpers.debugLog("initSignals: GatewayUserPosition")
            }
            try await userCtx?.start()
            await invokeUserSubscriptions()
            await userCtx?.onReconnecting { _ in
                Helpers.debugLog("initSignals: Disconnected")
            }
            await userCtx?.onReconnected {
                Helpers.debugLog("initSignals: Reconnected")
                await self.invokeUserSubscriptions()
            }
        } catch {
            Helpers.debugLog("initSignals: \(error)")
        }
    }
    
    func invokeUserSubscriptions() async {
        do {
            try await userCtx?.invoke(method: "SubscribeAccounts")
            try await userCtx?.invoke(method: "SubscribePositions", arguments: 12277723)
        } catch {
            Helpers.debugLog("invokeUserSubscriptions: \(error)")
        }
    }
}
