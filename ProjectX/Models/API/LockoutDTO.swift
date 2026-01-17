//
//  LockoutDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/17/26.
//

import Foundation

nonisolated struct LockoutDTO: Codable {
    var tradingAccountId: Int
    var userId: Int
    var createdAt: String
    var startsAt: String
    var expiresAt: String
}
