//
//  Order.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/7/26.
//

import Foundation
import SwiftUI

nonisolated struct Order: Identifiable, Equatable, Codable {
    var id: Int
    var accountId: Int
    var contractId: String
    var symbolId: String
    var creationTimestamp: String
    var updateTimestamp: String
    var status: Int
    var type: Int
    var side: Int
    var size: Int
    var limitPrice: Double?
    var stopPrice: Double?
    var trailPrice: Double?
    var fillVolumed: Int
    var filledPriced: Double?
    var customTag: String?
    
    static func fromDto(_ dto: OrderDTO) -> Order {
        return Order(
            id: dto.id,
            accountId: dto.accountId,
            contractId: dto.contractId,
            symbolId: dto.symbolId,
            creationTimestamp: dto.creationTimestamp,
            updateTimestamp: dto.updateTimestamp,
            status: dto.status,
            type: dto.type,
            side: dto.side,
            size: dto.size,
            limitPrice: dto.limitPrice,
            stopPrice: dto.stopPrice,
            trailPrice: dto.trailPrice,
            fillVolumed: dto.fillVolumed,
            filledPriced: dto.filledPriced,
            customTag: dto.customTag
        )
    }
    
    var tagString: String? {
        return customTag?.replacingOccurrences(of: "AutoBracket", with: "").replacingOccurrences(of: "-SL", with: "").replacingOccurrences(of: "-TP", with: "")
    }
    
    var ordeType: String {
        switch self.type {
        case 1:
            return "Limit"
        case 2:
            return "Market"
        case 4:
            return "Stop"
        case 5:
            return "Trailing Stop"
        case 6:
            return "Join Bid"
        case 7:
            return "Join Ask"
        default:
            return "Unknown"
        }
    }
    
    var points: Double? {
        if let limitPrice = limitPrice {
            return limitPrice
        }
        if let stopPrice = stopPrice {
            return stopPrice
        }
        if let trailPrice = trailPrice {
            return trailPrice
        }
        return nil
    }
}
