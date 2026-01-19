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
    case journal = "Journal"
    case notifications = "Notifications"
    case customization = "Customization"
    case developer = "Developer"
    case backups = "Backups"
    case about = "About"
    case donate = "Donate"
    
    var icon: String {
        switch self {
        case .configuration:
            return "slider.horizontal.3"
        case .journal:
            return "book.closed"
        case .notifications:
            return "bell"
        case .customization:
            return "paintpalette"
        case .developer:
            return "ant"
        case .backups:
            return "clock.arrow.trianglehead.2.counterclockwise.rotate.90"
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
        case .journal:
            return .indigo
        case .notifications:
            return .red
        case .customization:
            return .orange
        case .developer:
            return .green
        case .backups:
            return .purple
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
            return "Update TopstepX Credentials"
        case .journal:
            return "Manage Journal Logs"
        case .notifications:
            return "Setup Preferred Notifications"
        case .customization:
            return "Tweak User Experience"
        case .developer:
            return "Explore Developer Tools"
        case .backups:
            return "Browse Account Backups"
        case .about:
            return "View App Information"
        case .donate:
            return "Help Support Development"
        }
    }
}
