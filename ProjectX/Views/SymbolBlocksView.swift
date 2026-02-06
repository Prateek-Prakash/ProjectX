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
                                let contract = globalVM.getContract(block.symbolId)
                                let ticker = contract != nil ? contract!.productName.replacingOccurrences(of: "/", with: "") : "--"
                                let description = contract != nil ? "(\(contract!.description))" : "(--)"
                                OriginCard {
                                    GroupBox {
                                        HStack {
                                            Text(ticker)
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Text(description)
                                                .font(.system(size: 12, weight: .thin, design: .rounded))
                                                .foregroundStyle(.secondary)
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
