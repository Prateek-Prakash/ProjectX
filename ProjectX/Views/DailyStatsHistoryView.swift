//
//  DailyStatsHistoryView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/17/25.
//

import SwiftUI

struct DailyStatsHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !globalVM.accountDailyStats.isEmpty {
                    ScrollView {
                        OriginCard {
                            LazyVStack(spacing: 0) {
                                ForEach(Array(globalVM.accountDailyStats)) { stats in
                                    DailyStatsTile(stats: stats)
                                    if globalVM.accountDailyStats.last != stats {
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
                        Label("NO DAILY STATS", systemImage: "exclamationmark.triangle")
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
                    Text("DAILY STATS HISTORY")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
