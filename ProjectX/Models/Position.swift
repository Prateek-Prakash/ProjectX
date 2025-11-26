//
//  Position.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/26/25.
//

import Foundation

struct Position: Identifiable, Equatable, Codable {
    var id: Int
    var accountId: Int
    var contractId: String
    var symbolId: String
    var creationTimestamp: String
    var type: Int
    var size: Int
    var averagePrice: Double
    
    static func fromDto(_ dto: PositionDTO) -> Position {
        let first = dto.contractId.firstIndex(of: ".")!
        let last = dto.contractId.lastIndex(of: ".")!
        let symbol = String(dto.contractId[dto.contractId.index(after: first)..<last])
        return Position(
            id: dto.id,
            accountId: dto.accountId,
            contractId: dto.contractId,
            symbolId: symbol,
            creationTimestamp: dto.creationTimestamp,
            type: dto.type,
            size: dto.size,
            averagePrice: dto.averagePrice
        )
    }
}
