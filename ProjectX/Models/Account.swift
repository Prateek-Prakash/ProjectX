//
//  Account.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import Foundation
import SwiftUI

struct Account: Identifiable, Equatable {
    var id: Int { accountId }
    var firm: Firm
    var userId: Int
    var accountId: Int
    var accountName: String
    var nickname: String?
    var ineligible: Bool
    var canTrade: Bool
    var isLeader: Bool
    var isFollower: Bool
    var startingBalance: Double
    var startOfDayBalance: Double
    var balance: Double
    var realizedDayPnl: Double
    var openPnl: Double
    var positions: [Position]
    var orders: [Order]
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
    var autoOcoBrackets: Bool
    var winRate: Double
    
    var accountType: AccountType = .evaluation
    
    static func fromDto(_ dto: AccountDTO, _ firm: Firm, _ type: AccountType, _ tradable: Bool, _ positions: [Position], _ orders: [Order]) -> Account {
        return Account(
            firm: firm,
            userId: dto.userId,
            accountId: dto.accountId,
            accountName: dto.accountName,
            nickname: dto.nickname,
            ineligible: dto.ineligible,
            canTrade: tradable,
            isLeader: dto.isLeader,
            isFollower: dto.isFollower,
            startingBalance: dto.startingBalance,
            startOfDayBalance: dto.startOfDayBalance,
            balance: dto.balance,
            realizedDayPnl: dto.realizedDayPnl,
            openPnl: dto.openPnl,
            positions: positions,
            orders: orders,
            dailyLoss: dto.dailyLoss,
            maximumLoss: dto.maximumLoss,
            lockoutReason: dto.lockoutReason,
            lockoutExpiration: dto.lockoutExpiration,
            personalDailyProfitTarget: dto.personalDailyProfitTarget,
            personalDailyProfitTargetAction: dto.personalDailyProfitTargetAction,
            personalDailyLossLimit: dto.personalDailyLossLimit,
            personalDailyLossLimitAction: dto.personalDailyLossLimitAction,
            personalDailyLossLimitTrailing: dto.personalDailyLossLimitTrailing,
            pdllTrailingType: dto.pdllTrailingType,
            autoOcoBrackets: dto.autoOcoBrackets,
            winRate: dto.winRate,
            accountType: type
        )
    }
}
