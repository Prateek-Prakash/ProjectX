//
//  WinRateView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/23/25.
//

import SwiftUI

struct WinRateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
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
                Text("WIN RATE")
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    .tracking(2)
            }
        }
    }
}
