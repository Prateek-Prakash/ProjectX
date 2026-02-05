//
//  BracketsResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/4/26.
//

import Foundation
import SwiftUI

nonisolated struct BracketsResponseDTO: Codable {
    var success: Bool
    var result: Int
    var errorMessage: String?
}
