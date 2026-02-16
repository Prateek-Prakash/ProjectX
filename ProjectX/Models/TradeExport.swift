//
//  TradeExport.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/15/26.
//

import Foundation

struct TradeExport: Identifiable, Codable {
    var id: Int
    var date: String
    var side: String
    var ticker: String
    var size: Int
    var pnl: Double
    var fees: Double
    var mfe: Double?
    var mae: Double?
    var entryPrice: Double
    var exitPrice: Double
    var entryAt: String
    var exitAt: String
    var duration: String
    
    var bars: [BarDTO]? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date = "date"
        case side = "side"
        case ticker = "ticker"
        case size = "size"
        case pnl = "pnl"
        case fees = "fees"
        case mfe = "mfe"
        case mae = "mae"
        case entryPrice = "entryPrice"
        case exitPrice = "exitPrice"
        case entryAt = "entryAt"
        case exitAt = "exitAt"
        case duration = "duration"
        case bars = "bars"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(side, forKey: .side)
        try container.encode(ticker, forKey: .ticker)
        try container.encode(size, forKey: .size)
        try container.encode(pnl, forKey: .pnl)
        try container.encode(fees, forKey: .fees)
        try container.encode(mfe, forKey: .mfe)
        try container.encode(mae, forKey: .mae)
        try container.encode(entryPrice, forKey: .entryPrice)
        try container.encode(exitPrice, forKey: .exitPrice)
        try container.encode(entryAt, forKey: .entryAt)
        try container.encode(exitAt, forKey: .exitAt)
        try container.encode(duration, forKey: .duration)
        try container.encode(bars, forKey: .bars)
    }
}
