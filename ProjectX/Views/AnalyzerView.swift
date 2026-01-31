//
//  AnalyzerView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/30/26.
//

import SwiftUI

struct AnalyzerView: View {
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
            }
        }
    }
}
