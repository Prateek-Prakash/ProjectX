//
//  TradeDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/2/25.
//

import Foundation

nonisolated struct TradeDTO: Identifiable, Codable {
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
}
