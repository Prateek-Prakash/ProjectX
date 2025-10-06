//
//  FirmLabel.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/24/25.
//

import SwiftUI

struct FirmLabel: View {
    let firm: Firm
    let count: Int
    let showCount: Bool
    let showIcon: Bool
    
    var body: some View {
        HStack {
            if showIcon {
                Image(firm.displayName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(.circle)
            }
            Text(firm.displayName + (showCount ? "  •  \(count)" : ""))
                .font(.system(size: 12, weight: .bold, design: .rounded))
        }
    }
}
