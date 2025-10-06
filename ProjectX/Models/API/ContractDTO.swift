//
//  ContractDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/1/25.
//

import Foundation

nonisolated struct ContractDTO: Identifiable, Codable {
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
}
