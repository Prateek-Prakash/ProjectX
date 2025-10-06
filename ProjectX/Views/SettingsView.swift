//
//  SettingsView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(SettingsSection.allCases) { section in
                            NavigationLink {
                                getTargetView(section)
                            } label: {
                                SettingsCard(section: section)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("SETTINGS")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    CloseButton()
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        .interactiveDismissDisabled()
    }
    
    @ViewBuilder func getTargetView(_ section: SettingsSection) -> some View {
        switch section {
        case SettingsSection.configuration:
            ConfigurationView()
        case SettingsSection.automation:
            AutomationView()
        case SettingsSection.notifications:
            NotificationsView()
        case SettingsSection.customization:
            CustomizationView()
        case SettingsSection.developer:
            DeveloperView()
        case SettingsSection.about:
            AboutView()
        case SettingsSection.donate:
            DonateView()
        }
    }
}
