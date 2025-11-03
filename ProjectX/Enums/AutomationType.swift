//
//  AutomationType.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/5/25.
//

import Foundation
import SwiftUI

enum AutomationType {
    case full
    case semi
    case zero
    case unknown
    
    var icon: String {
        switch self {
        case .full:
            return "checkmark.circle.fill"
        case .semi:
            return "minus.circle.fill"
        case .zero:
            return "xmark.circle.fill"
        case .unknown:
            return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .full:
            return .green
        case .semi:
            return .yellow
        case .zero:
            return .red
        case .unknown:
            return .gray
        }
    }
}
