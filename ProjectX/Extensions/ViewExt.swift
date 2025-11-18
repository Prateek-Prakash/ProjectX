//
//  ViewExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/18/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func snapshot(trigger: Bool, onComplete: @escaping (UIImage) -> ()) -> some View {
        self.modifier(SnapshotModifier(trigger: trigger, onComplete: onComplete))
    }
}

fileprivate struct SnapshotModifier: ViewModifier {
    var trigger: Bool
    var onComplete: (UIImage) -> ()
    
    @State private var view: UIView = .init(frame: .zero)
    
    func body(content: Content) -> some View {
        content
            .background(ViewExtractor(view: view))
            .compositingGroup()
            .onChange(of: trigger) { oldValue, newValue in
                generateSnapshot()
            }
    }
    
    private func generateSnapshot() {
        if let superView = view.superview?.superview {
            let render = UIGraphicsImageRenderer(size: superView.bounds.size)
            let image = render.image { _ in
                superView.drawHierarchy(in: superView.bounds, afterScreenUpdates: true)
            }
            onComplete(image)
        }
    }
}

fileprivate struct ViewExtractor: UIViewRepresentable {
    var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
