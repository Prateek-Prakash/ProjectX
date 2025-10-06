//
//  AccountType.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/5/25.
//

import Foundation
import SwiftUI

enum AccountType {
    case evaluation
    case funded
    case practice
    
    var typeColor: Color {
        switch self {
        case .evaluation:
            return .gray
        case .funded:
            return .blue
        case .practice:
            return .purple
        }
    }
}
