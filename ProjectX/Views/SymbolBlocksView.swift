//
//  SymbolBlockView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/5/26.
//

import SwiftUI

struct SymbolBlocksView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let account: Account
    
    @State var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if globalVM.loadingSymbolBlocks {
                    ProgressView()
                } else if !globalVM.symbolBlocks.isEmpty || isEditing {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(globalVM.symbolBlocks, id: \.symbolId) { block in
                                let contract = globalVM.getContract(block.symbolId)
                                let ticker = contract != nil ? contract!.productName.replacingOccurrences(of: "/", with: "") : "--"
                                let description = contract != nil ? "(\(contract!.description))" : "(--)"
                                Button {
                                    if isEditing {
                                        HapticViewModel.shared.selectionHaptic()
                                        
                                        // Remove Block
                                        globalVM.symbolBlocks.removeAll(where: { $0.symbolId == block.symbolId })
                                    }
                                } label: {
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
                                                    .imageScale(.medium)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                            if isEditing {
                                ForEach(globalVM.allContracts[account.firm]!) { contract in
                                    if !globalVM.symbolBlocks.contains(where:  { $0.symbolId == contract.productId }) {
                                        let ticker = contract.productName.replacingOccurrences(of: "/", with: "")
                                        let description = "(\(contract.description))"
                                        Button {
                                            if isEditing {
                                                HapticViewModel.shared.selectionHaptic()
                                                
                                                // Add Block
                                                var blocks = globalVM.symbolBlocks
                                                let block = SymbolBlock(
                                                    id: 0,
                                                    symbolId: contract.productId,
                                                    accountId: account.id
                                                )
                                                blocks.append(block)
                                                globalVM.symbolBlocks = blocks.sorted(by: { $0.symbolId < $1.symbolId })
                                                
                                            }
                                        } label: {
                                            OriginCard {
                                                GroupBox {
                                                    HStack {
                                                        Text(ticker)
                                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                                        Text(description)
                                                            .font(.system(size: 12, weight: .thin, design: .rounded))
                                                            .foregroundStyle(.secondary)
                                                        Spacer()
                                                        Image(systemName: "checkmark.circle")
                                                            .foregroundStyle(.green)
                                                            .fontDesign(.rounded)
                                                            .imageScale(.medium)
                                                    }
                                                    .frame(height: 12)
                                                }
                                                .backgroundStyle(Color(.xCardBackground))
                                            }
                                        }
                                        .buttonStyle(.plain)
                                    }
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
                    if isEditing {
                        let blocks = globalVM.symbolBlocks.map(\.symbolId)
                        Task {
                            let success = await XClient.get(account.firm).setSymbolBlocks(account.id, blocks)
                            if !success {
                                await globalVM.loadSymbolBlocks()
                            }
                        }
                    }
                    isEditing .toggle()
                } label: {
                    Image(systemName: isEditing ? "checkmark.circle" : "pencil.circle")
                        .imageScale(.medium)
                        .increaseTapArea(by: 12)
                }
                .buttonStyle(.plain)
                .disabled(globalVM.loadingSymbolBlocks)
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .task {
            await globalVM.loadSymbolBlocks()
        }
    }
}
