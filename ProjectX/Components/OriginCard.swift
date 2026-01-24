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
    
    init(color: Color? = nil, @ViewBuilder content: () -> Content) {
        self.color = color
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            ZStack {
                content
            }
            .background(Color(.xCardBackground))
        }
        .clipShape(.rect(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color ?? Color(.xOutline), lineWidth:  1))
    }
}
