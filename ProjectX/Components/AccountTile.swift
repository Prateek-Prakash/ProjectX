//
//  AccountTile.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import SwiftUI

struct AccountTile: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let account: Account
    let tappable: Bool
    
    @State var showPerformanceCover: Bool = false
    
    var body: some View {
        Button {
            if tappable {
                Task {
                    globalVM.loadingTrades = true
                    if globalVM.delayLoadingTrades {
                        try! await Task.sleep(for: .seconds(5))
                    }
                    globalVM.selectedAccount = account
                    await globalVM.loadDailyStats(account)
                    await globalVM.loadTrades(account)
                    globalVM.loadingTrades = false
                }
                showPerformanceCover.toggle()
            }
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "circle")
                    .font(.system(size: 6))
                    .foregroundStyle(account.accountType.typeColor)
                    .shadow(color: account.accountType.typeColor, radius: 3)
                    .shadow(color: account.accountType.typeColor, radius: 3)
                    .padding(.trailing, 14)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text((globalVM.subtractStartingBalance ? account.balance - account.startingBalance : account.balance).asCurrency())
                    HStack(spacing: 4) {
                        Image(systemName: account.isLeader ? "l.square.fill" : "l.square")
                            .foregroundStyle(account.isLeader ? .primary : .secondary)
                            .imageScale(.small)
                        Image(systemName: account.isFollower ? "f.square.fill" : "f.square")
                            .foregroundStyle(account.isFollower ? .primary : .secondary)
                            .imageScale(.small)
                        Text(account.nickname ?? "...\(account.accountName.suffix(4))")
                            .font(.system(size: 8, weight: .thin, design: .monospaced))
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Text(abs(account.realizedDayPnl).asCurrency())
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(account.realizedDayPnl > 0 ? .green : account.realizedDayPnl < 0 ? .red : .gray)
                
                Image(systemName: "circle.fill")
                    .font(.system(size: 4))
                    .foregroundStyle(account.statusColor)
                    .shadow(color: account.statusColor, radius: 3)
                    .padding(.leading, 14)
            }
            .contentShape(.rect)
            .padding(.all, 14)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showPerformanceCover) {
            PerformanceView(account: account)
        }
    }
}
