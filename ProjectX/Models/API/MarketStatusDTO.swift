//
//  MarketStatusDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/18/26.
//

import Foundation

nonisolated struct MarketStatusDTO: Codable {
    var isOpen: Bool
    var nextOpen: String
    var close: String
}
