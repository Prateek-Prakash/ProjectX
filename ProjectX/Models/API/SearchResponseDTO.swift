//
//  SearchResponseDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/18/25.
//

import Foundation
import SwiftUI

nonisolated struct SearchResponseDTO: Codable {
    var accounts: [SearchDTO]
    var success: Bool
    var errorCode: Int
    var errorMessage: String?
}
