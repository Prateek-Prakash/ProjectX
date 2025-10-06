//
//  SettingsCard.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SwiftUI

struct SettingsCard: View {
    let section: SettingsSection
    
    var body: some View {
        OriginCard {
            HStack {
                Image(systemName: section.icon)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(section.color.mix(with: .white, by: 0.2))
                    .background(section.color.tertiary)
                    .clipShape(.rect(cornerRadius: 6))
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.title.uppercased())
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .tracking(2)
                    Text(section.description.uppercased())
                        .font(.system(size: 8, weight: .medium, design: .rounded))
                        .tracking(1.25)
                        .foregroundStyle(.secondary)
                }
                .padding(.leading, 8)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color(.xOutline))
                    .fontDesign(.rounded)
            }
            .padding(.all, 14)
            .background(Color(.xCardBackground))
        }
    }
}
