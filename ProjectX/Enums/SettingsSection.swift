//
//  SettingsSection.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import Foundation
import SwiftUI

enum SettingsSection: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case configuration = "Configuration"
    case automation = "Automation"
    case notifications = "Notifications"
    case customization = "Customization"
    case developer = "Developer"
    case about = "About"
    case donate = "Donate"
    
    var icon: String {
        switch self {
        case .configuration:
            return "slider.horizontal.3"
        case .automation:
            return "sparkles"
        case .notifications:
            return "bell"
        case .customization:
            return "paintpalette"
        case .developer:
            return "ant"
        case .about:
            return "questionmark.circle"
        case .donate:
            return "heart"
        }
    }
    
    var color: Color {
        switch self {
        case .configuration:
            return .cyan
        case .automation:
            return .indigo
        case .notifications:
            return .red
        case .customization:
            return .orange
        case .developer:
            return .green
        case .about:
            return .gray
        case .donate:
            return .pink
        }
    }
    
    var title: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .configuration:
            return "Manage ProjectX Connections"
        case .automation:
            return "Configure ATS Options"
        case .notifications:
            return "Setup Preferred Notifications"
        case .customization:
            return "Tweak User Experience"
        case .developer:
            return "Explore Developer Tools"
        case .about:
            return "View App Information"
        case .donate:
            return "Help Support Development"
        }
    }
}
