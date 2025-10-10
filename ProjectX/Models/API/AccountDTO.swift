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
}
