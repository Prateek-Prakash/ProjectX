//
//  LockoutResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/17/26.
//

import Foundation
import SwiftUI

nonisolated struct LockoutResponseDTO: Codable {
    var id: Int
    var message: String
    var success: Bool
}
