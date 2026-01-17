//
//  CloseResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/17/26.
//

import Foundation
import SwiftUI

nonisolated struct CloseResponseDTO: Codable {
    var success: Bool
    var errorCode: Int
    var errorMessage: String?
}
