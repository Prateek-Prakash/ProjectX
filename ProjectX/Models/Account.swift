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
    var ineligible: Bool
    var isLeader: Bool
    var isFollower: Bool
    var startingBalance: Double
    var balance: Double
    var realizedDayPnl: Double
    var openPnl: Double
    var dailyLoss: Double
    var lockoutReason: String?
    var lockoutExpiration: String?
    var winRate: Double
    
    var accountType: AccountType = .evaluation
    
    var winningColor: Color {
        return self.realizedDayPnl >= self.firm.winningDay ? .green : .gray
    }
    
    static func fromDto(_ dto: AccountDTO, _ firm: Firm, _ type: AccountType) -> Account {
        return Account(
            firm: firm,
            userId: dto.userId,
            accountId: dto.accountId,
            accountName: dto.accountName,
            ineligible: dto.ineligible,
            isLeader: dto.isLeader,
            isFollower: dto.isFollower,
            startingBalance: dto.startingBalance,
            balance: dto.balance,
            realizedDayPnl: dto.realizedDayPnl,
            openPnl: dto.openPnl,
            dailyLoss: dto.dailyLoss,
            lockoutReason: dto.lockoutReason,
            lockoutExpiration: dto.lockoutExpiration,
            winRate: dto.winRate,
            accountType: type
        )
    }
}
