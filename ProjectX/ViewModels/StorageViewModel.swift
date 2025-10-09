//
//  StorageViewModel.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/9/25.
//

import Combine
import Foundation
import SwiftUI

@MainActor
class StorageViewModel: ObservableObject {
    static let shared = StorageViewModel()
    
    // AlphaFuturesX
    @AppStorage("alphaFuturesUsername") var alphaFuturesUsername: String = ""
    @AppStorage("alphaFuturesKey") var alphaFuturesKey: String = ""
    @AppStorage("alphaFuturesFunded") var alphaFuturesFunded: [Int] = []
    @AppStorage("alphaFuturesPractice") var alphaFuturesPractice: [Int] = []
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
    
    // Developer
    @AppStorage("automaticRefresh") var automaticRefresh: Bool = false
    @AppStorage("delayAuthentication") var delayAuthentication: Bool = false
    @AppStorage("delayLoadingTrades") var delayLoadingTrades: Bool = false
}
