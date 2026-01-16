//
//  OriginCard.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/19/25.
//

import SwiftUI

struct OriginCard<Content: View>: View {
    let content: Content
    let color: Color?
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.color = nil
    }
    
    init(@ViewBuilder content: () -> Content, @ViewBuilder color: () -> Color?) {
        self.content = content()
        self.color = color()
    }
    
    var body: some View {
        ZStack {
            ZStack {
                content
            }
            .background(color?.opacity(0.15) ?? Color(.xCardBackground))
        }
        .clipShape(.rect(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color?.opacity(0.45) ?? Color(.xOutline), lineWidth: 1))
    }
}
