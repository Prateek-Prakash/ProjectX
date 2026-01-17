//
//  Donation.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/16/26.
//

import Foundation

struct Donation: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let url: URL
}
