//
//  PositionDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/26/25.
//

import Foundation
import SwiftUI

nonisolated struct PositionDTO: Identifiable, Codable {
    var id: Int
    var accountId: Int
    var contractId: String
    var creationTimestamp: String
    var type: Int
    var size: Int
    var averagePrice: Double
}
