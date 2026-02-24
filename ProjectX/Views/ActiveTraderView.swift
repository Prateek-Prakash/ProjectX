//
//  ActiveTraderView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/30/26.
//

import SwiftUI

struct ActiveTraderView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var showContractsSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
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
                    Text("ACTIVE TRADER")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showContractsSheet.toggle()
                    } label: {
                        Image(systemName: "dot.scope")
                            .imageScale(.small)
                            .increaseTapArea(by: 12)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .sheet(isPresented: $showContractsSheet) {
                ContractsSheet()
            }
        }
    }
}
