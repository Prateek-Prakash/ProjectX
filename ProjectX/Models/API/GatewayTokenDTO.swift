//
//  GatewayTokenDTO.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/1/25.
//

import Foundation

nonisolated struct GatewayTokenDTO: Codable {
    var token: String?
    var success: Bool?
    var errorCode: Int?
    var errorMessage: String?
}
