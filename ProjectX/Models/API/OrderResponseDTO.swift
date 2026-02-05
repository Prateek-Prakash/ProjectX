//
//  OrderResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/5/26.
//

import Foundation
import SwiftUI

nonisolated struct OrderResponseDTO: Codable {
    var orders: [OrderDTO]
    var success: Bool
    var errorCode: Int
    var errorMessage: String?
}
