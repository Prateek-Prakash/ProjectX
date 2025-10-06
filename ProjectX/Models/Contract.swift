//
//  Contract.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import Foundation

struct Contract: Identifiable {
    var id: String { contractId }
    var productId: String
    var productName: String
    var contractId: String
    var contractName: String
    var tickValue: Double
    var tickSize: Double
    var pointValue: Double
    var exchangeFee: Double
    var regulatoryFee: Double
    var commissionFee: Double
    var totalFees: Double
    var description: String
    var disabled: Bool
    var decimalPlaces: Int
    var priceScale: Double
    var minMove: Double
    var fractionalPrice: Bool
    var exchange: String
    var minMove2: Double
    var isProfessional: Bool
    
    static func fromDto(_ dto: ContractDTO) -> Contract {
        return Contract(
            productId: dto.productId,
            productName: dto.productName,
            contractId: dto.contractId,
            contractName: dto.contractName,
            tickValue: dto.tickValue,
            tickSize: dto.tickSize,
            pointValue: dto.pointValue,
            exchangeFee: dto.exchangeFee,
            regulatoryFee: dto.regulatoryFee,
            commissionFee: dto.commissionFee,
            totalFees: dto.totalFees,
            description: dto.description,
            disabled: dto.disabled,
            decimalPlaces: dto.decimalPlaces,
            priceScale: dto.priceScale,
            minMove: dto.minMove,
            fractionalPrice: dto.fractionalPrice,
            exchange: dto.exchange,
            minMove2: dto.minMove2,
            isProfessional: dto.isProfessional
        )
    }
}
