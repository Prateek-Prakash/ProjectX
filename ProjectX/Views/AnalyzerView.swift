//
//  AnalyzerView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/30/26.
//

import SwiftUI

struct AnalyzerView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.displayScale) var displayScale
    @State private var viewWidth: CGFloat = 0
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ContentUnavailableView {
                    Label("WORK-IN-PROGRESS", systemImage: "wrench.and.screwdriver")
                        .imageScale(.small)
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { size in
                viewWidth = size.width
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("ANALYZER")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Select
                    } label: {
                        Image(systemName: "dot.scope")
                            .imageScale(.small)
                            .increaseTapArea(by: 12)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}
