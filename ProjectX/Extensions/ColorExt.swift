//
//  ColorExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/7/26.
//

import SwiftUI

extension Color {
    static func fromString(_ uuidString: String?) -> Color {
        guard let input = uuidString, !input.isEmpty else {
            return Color.secondary
        }

        var hasher = Hasher()
        hasher.combine(input.lowercased())
        let hash = abs(hasher.finalize())

        let r = Double((hash & 0xFF0000) >> 16) / 255.0
        let g = Double((hash & 0x00FF00) >> 8) / 255.0
        let b = Double(hash & 0x0000FF) / 255.0

        return Color(red: r, green: g, blue: b)
    }
}
