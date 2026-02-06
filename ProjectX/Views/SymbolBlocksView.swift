//
//  SymbolBlockView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/5/26.
//

import SwiftUI

struct SymbolBlocksView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if globalVM.loadingSymbolBlocks {
                    ProgressView()
                } else if !globalVM.symbolBlocks.isEmpty {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(globalVM.symbolBlocks, id: \.symbolId) { block in
                                OriginCard {
                                    GroupBox {
                                        HStack {
                                            Text(block.symbolId)
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Image(systemName: "nosign")
                                                .foregroundStyle(.red)
                                                .fontDesign(.rounded)
                                                .imageScale(.small)
                                        }
                                        .frame(height: 12)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                } else {
                    ContentUnavailableView {
                        Label("NO BLOCKS FOUND", systemImage: "exclamationmark.triangle")
                            .imageScale(.small)
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
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
                Text("SYMBOL BLOCKS")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .tracking(2)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: Edit
                } label: {
                    Image(systemName: "pencil")
                        .imageScale(.small)
                        .increaseTapArea(by: 12)
                }
                .buttonStyle(.plain)
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .task {
            await globalVM.loadSymbolBlocks()
        }
    }
}
