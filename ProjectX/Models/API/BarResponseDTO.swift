//
//  BarResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/3/26.
//

import Foundation
import SwiftUI

nonisolated struct BarResponseDTO: Codable {
    var bars: [BarDTO]
    var success: Bool
    var errorCode: Int
    var errorMessage: String?
}
