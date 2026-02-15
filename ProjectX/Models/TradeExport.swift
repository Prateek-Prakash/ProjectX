//
//  TradeExport.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/15/26.
//

import Foundation

struct TradeExport: Identifiable, Codable {
    var id: Int
    var tradeDate: String
    var side: String
    var ticker: String
    var size: Int
    var pnl: Double
    var points: Double
    var fees: Double
    var runUpPoints: Double?
    var runUpDollars: Double?
    var drawdownPoints: Double?
    var drawdownDollars: Double?
    var entryPrice: Double
    var exitPrice: Double
    var entryAt: String
    var exitAt: String
    var duration: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tradeDate = "tradeDate"
        case side = "side"
        case ticker = "ticker"
        case size = "size"
        case pnl = "pnl"
        case points = "points"
        case fees = "fees"
        case runUpPoints = "runUpPoints"
        case runUpDollars = "runUpDollars"
        case drawdownPoints = "drawdownPoints"
        case drawdownDollars = "drawdownDollars"
        case entryPrice = "entryPrice"
        case exitPrice = "exitPrice"
        case entryAt = "entryAt"
        case exitAt = "exitAt"
        case duration = "duration"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tradeDate, forKey: .tradeDate)
        try container.encode(side, forKey: .side)
        try container.encode(ticker, forKey: .ticker)
        try container.encode(size, forKey: .size)
        try container.encode(pnl, forKey: .pnl)
        try container.encode(points, forKey: .points)
        try container.encode(fees, forKey: .fees)
        try container.encode(runUpPoints, forKey: .runUpPoints)
        try container.encode(runUpDollars, forKey: .runUpDollars)
        try container.encode(drawdownPoints, forKey: .drawdownPoints)
        try container.encode(drawdownDollars, forKey: .drawdownDollars)
        try container.encode(entryPrice, forKey: .entryPrice)
        try container.encode(exitPrice, forKey: .exitPrice)
        try container.encode(entryAt, forKey: .entryAt)
        try container.encode(exitAt, forKey: .exitAt)
        try container.encode(duration, forKey: .duration)
    }
}
