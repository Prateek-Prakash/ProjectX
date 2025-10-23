//
//  TradeHistoryView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/20/25.
//

import SwiftUI

struct TradeHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !globalVM.accountTrades.isEmpty {
                    ScrollView {
                        OriginCard {
                            LazyVStack(spacing: 0) {
                                ForEach(globalVM.accountTrades) { trade in
                                    TradeTile(trade: trade)
                                    if globalVM.accountTrades.last != trade {
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                } else {
                    ContentUnavailableView {
                        Label("NO TRADES", systemImage: "exclamationmark.triangle")
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
                    Text("TRADE HISTORY")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
