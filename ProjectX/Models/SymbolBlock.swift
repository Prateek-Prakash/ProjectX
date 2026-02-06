//
//  SymbolBlock.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/6/26.
//

import Foundation

struct SymbolBlock: Equatable {
    var id: Int
    var symbolId: String
    var accountId: Int
    
    static func fromDto(_ dto: SymbolBlockDTO) -> SymbolBlock {
        return SymbolBlock(
            id: dto.id,
            symbolId: dto.symbolId,
            accountId: dto.accountId
        )
    }
}
