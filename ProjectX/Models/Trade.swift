//
//  Trade.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/24/25.
//

import Foundation

struct Trade: Identifiable, Equatable {
    var id: Int
    var symbolId: String
    var contractId: String?
    var accountId: Int
    var createdAt: String
    var tradeDay: String
    var exitedAt: String
    var entryPrice: Double
    var exitPrice: Double
    var fees: Double
    var pnL: Double
    var positionSize: Int
    var voided: Bool
    var tradeDuration: String
    var tradeDurationDisplay: String
    
    static func fromDto(_ dto: TradeDTO) -> Trade {
        return Trade(
            id: dto.id,
            symbolId: dto.symbolId,
            contractId: dto.contractId,
            accountId: dto.accountId,
            createdAt: dto.createdAt,
            tradeDay: dto.tradeDay,
            exitedAt: dto.exitedAt,
            entryPrice: dto.entryPrice,
            exitPrice: dto.exitPrice,
            fees: dto.fees,
            pnL: dto.pnL,
            positionSize: dto.positionSize,
            voided: dto.voided,
            tradeDuration: dto.tradeDuration,
            tradeDurationDisplay: dto.tradeDurationDisplay
        )
    }
}
