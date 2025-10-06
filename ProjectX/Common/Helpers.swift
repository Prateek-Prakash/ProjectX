//
//  Helpers.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/6/25.
//

import Foundation

struct Helpers {
    static func debugLog(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        print("[\(formatter.string(from: Date.now))] \(message)")
    }
}
