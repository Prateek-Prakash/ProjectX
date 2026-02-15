//
//  DailyStatsTile.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/17/25.
//

import SwiftUI

struct DailyStatsTile: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let stats: DailyStats
    
    @State var showDailyStatsInfoSheet: Bool = false
    
    var body: some View {
        Button {
            Task {
                await globalVM.calculateStatsInfo(stats.tradeDate)
            }
            showDailyStatsInfoSheet.toggle()
        } label: {
            HStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(stats.tradeDate.asDate())
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        Text(stats.tradeDate.asTime())
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .center) {
                    Text(String(stats.totalTrades))
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                    Text("TRADES")
                        .font(.system(size: 6, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(abs(stats.totalPnL - stats.totalFees).asCurrency())
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .foregroundStyle((stats.totalPnL - stats.totalFees) > 0 ? .green : (stats.totalPnL - stats.totalFees) < 0 ? .red : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.all, 14)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDailyStatsInfoSheet) {
            DailyStatsInfoSheet(stats: stats)
        }
    }
}
