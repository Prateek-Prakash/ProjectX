//
//  PositionResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/26/25.
//

import Foundation
import SwiftUI

nonisolated struct PositionResponseDTO: Codable {
    var positions: [PositionDTO]
    var success: Bool
    var errorCode: Int
    var errorMessage: String?
}
