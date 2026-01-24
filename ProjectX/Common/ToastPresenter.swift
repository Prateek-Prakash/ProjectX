//
//  ToastPresenter.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/24/26.
//

import SwiftUI

struct ToastPresenter: ViewModifier {
    @Binding var isPresented: Bool
    
    let duration: TimeInterval
    let icon: String?
    let message: String
    let tint: Color?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isPresented {
                    HStack {
                        if let icon {
                            Image(systemName: icon)
                                .foregroundStyle(tint != nil ? .white : Color(uiColor: .label))
                        }
                        
                        Text(message)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(tint != nil ? .white : Color(uiColor: .label))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical)
                    .glassEffect(.regular.tint(tint))
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.default, value: isPresented)
            .task(id: isPresented) {
                guard isPresented else { return }
                try? await Task.sleep(for: .seconds(duration))
                isPresented = false
            }
    }
}
