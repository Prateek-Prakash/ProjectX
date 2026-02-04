//
//  TapAreaModifier.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/4/26.
//

import SwiftUI

struct TapAreaModifier: ViewModifier {
    let extraPadding: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(extraPadding)
            .background(.clear)
            .contentShape(.rect)
    }
}

extension View {
    func increaseTapArea(by extraPadding: CGFloat) -> some View {
        self.modifier(TapAreaModifier(extraPadding: extraPadding))
    }
}
