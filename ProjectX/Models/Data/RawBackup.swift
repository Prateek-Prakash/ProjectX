//
//  RawBackup.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/21/25.
//

import Foundation
import SwiftData

@Model
class RawBackup: Identifiable, Hashable, Codable {
    var id: String { name }
    var firm: String = "--"
    var name: String = "--"
    var json: String = "--"
    var timestamp: String = "--"
    
    init(firm: String, name: String, json: String, timestamp: String) {
        self.firm = firm
        self.name = name
        self.json = json
        self.timestamp = timestamp
    }
    
    enum CodingKeys: String, CodingKey {
        case firm = "firm"
        case name = "name"
        case json = "json"
        case timestamp = "timestamp"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firm = try container.decode(String.self, forKey: .firm)
        name = try container.decode(String.self, forKey: .name)
        json = try container.decode(String.self, forKey: .json)
        timestamp = try container.decode(String.self, forKey: .timestamp)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firm, forKey: .firm)
        try container.encode(name, forKey: .name)
        try container.encode(json, forKey: .json)
        try container.encode(timestamp, forKey: .timestamp)
    }
    
    func update(_ json: String) {
        self.json = json
        self.timestamp = Date.now.ISO8601Format()
    }
}
