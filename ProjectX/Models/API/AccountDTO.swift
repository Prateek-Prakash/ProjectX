//
//  AccountDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import Foundation
import SwiftUI

nonisolated struct AccountDTO: Identifiable, Codable {
    var id: Int { accountId }
    var userId: Int
    var accountId: Int
    var accountName: String
    var nickname: String?
    var ineligible: Bool
    var isLeader: Bool
    var isFollower: Bool
    var startingBalance: Double
    var startOfDayBalance: Double
    var balance: Double
    var realizedDayPnl: Double
    var openPnl: Double
    var dailyLoss: Double
    var maximumLoss: Double
    var lockoutReason: String?
    var lockoutExpiration: String?
    var personalDailyProfitTarget: Int?
    var personalDailyProfitTargetAction: Int
    var personalDailyLossLimit: Int?
    var personalDailyLossLimitAction: Int
    var personalDailyLossLimitTrailing: Bool
    var pdllTrailingType: Int
    var winRate: Double
}
