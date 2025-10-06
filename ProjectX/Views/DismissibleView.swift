//
//  DismissibleView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/24/25.
//

import SwiftUI

struct DismissibleView<Content: View>: View {
    @Environment(\.dismiss) var dismiss
    
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                    }
                }
        }
    }
}
