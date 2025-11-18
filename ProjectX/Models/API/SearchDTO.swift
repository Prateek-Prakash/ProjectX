//
//  SearchDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/18/25.
//

import Foundation
import SwiftUI

nonisolated struct SearchDTO: Identifiable, Codable {
    var id: Int
    var name: String
    var balance: Double
    var canTrade: Bool
    var isVisible: Bool
}
