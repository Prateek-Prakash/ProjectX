//
//  DailyStatsDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/17/25.
//

import Foundation

nonisolated struct DailyStatsDTO: Identifiable, Codable {
    var id: String { tradeDate }
    var tradeDate: String
    var totalPnL: Double
    var totalTrades: Int
    var winningTrades: Int
    var losingTrades: Int
    var neutralTrades: Int
    var winRate: Double
    var totalFees: Double
}
