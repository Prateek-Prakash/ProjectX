//
//  TradeTimeView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/23/25.
//

import SwiftUI

struct TradeTimeView: View {
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
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .title) {
                Text("TRADE TIME")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .tracking(2)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: Filter
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .imageScale(.small)
                }
                .buttonStyle(.plain)
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}
