//
//  OrderDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/5/26.
//

import Foundation
import SwiftUI

nonisolated struct OrderDTO: Identifiable, Codable {
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
}
