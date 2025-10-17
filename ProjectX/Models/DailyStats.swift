//
//  DailyStats.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/17/25.
//

import Foundation

struct DailyStats: Identifiable, Equatable {
    var id: String { tradeDate }
    var tradeDate: String
    var totalPnL: Double
    var totalTrades: Int
    var winningTrades: Int
    var losingTrades: Int
    var neutralTrades: Int
    var winRate: Double
    var totalFees: Double
    
    static func fromDto(_ dto: DailyStatsDTO) -> DailyStats {
        return DailyStats(
            tradeDate: dto.tradeDate,
            totalPnL: dto.totalPnL,
            totalTrades: dto.totalTrades,
            winningTrades: dto.winningTrades,
            losingTrades: dto.losingTrades,
            neutralTrades: dto.neutralTrades,
            winRate: dto.winRate,
            totalFees: dto.totalFees
        )
    }
}
