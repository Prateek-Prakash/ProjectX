//
//  QuoteDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/1/25.
//

import Foundation

nonisolated struct QuoteDTO: Identifiable, Codable {
    var id: String { symbol }
    var symbol: String
    var symbolName: String?
    var lastPrice: Double?
    var bestBid: Double?
    var bestAsk: Double?
    var change: Double?
    var changePercent: Double?
    var open: Double?
    var high: Double?
    var low: Double?
    var volume: Int?
    var lastUpdated: String
    var timestamp: String
}
