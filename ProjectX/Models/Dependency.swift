//
//  Dependency.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/28/25.
//

import Foundation

struct Dependency: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let version: String
    let url: URL
}
