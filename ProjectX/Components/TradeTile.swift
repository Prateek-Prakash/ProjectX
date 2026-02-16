//
//  TradeTile.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/19/25.
//

import SwiftUI

struct TradeTile: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let firm: Firm
    let trade: Trade
    let tappable: Bool
    
    @State var showTradeInfoSheet: Bool = false
    
    var body: some View {
        Button {
            if tappable {
                globalVM.loadingTradeInfo = true
                Task {
                    await globalVM.calculateTradeInfo(firm, trade)
                }
                showTradeInfoSheet.toggle()
            }
        } label: {
            HStack {
                HStack {
                    Image(systemName: trade.positionSize < 0 ? "arrowtriangle.up.fill" : trade.positionSize > 0 ? "arrowtriangle.down.fill" : "questionmark")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(trade.positionSize < 0 ? .green : trade.positionSize > 0 ? .red : .primary)
                    Text(globalVM.getTickerId(firm, trade.symbolId))
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                    Spacer()
                }
                .frame(width: 50)
                
                
                VStack {
                    Text(String(abs(trade.positionSize)))
                        .font(.system(size: 10, design: .monospaced))
                }
                .frame(width: 20)
                
                VStack {
                    Text(trade.entryPrice.asPoints(globalVM.getTickerDigits(firm, trade.symbolId)))
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                    Text(trade.createdAt.asFractionalDate())
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(.secondary)
                    Text(trade.createdAt.asFractionalTime())
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text(trade.exitPrice.asPoints(globalVM.getTickerDigits(firm, trade.symbolId)))
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                    Text(trade.exitedAt.asFractionalDate())
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(.secondary)
                    Text(trade.exitedAt.asFractionalTime())
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(abs(trade.pnL).asCurrency())
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundStyle(trade.pnL > 0 ? .green : trade.pnL < 0 ? .red : .gray)
                        Text(trade.fees.asCurrency())
                            .font(.system(size: 8, weight: .light, design: .monospaced))
                            .foregroundStyle(.red)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.all, 14)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showTradeInfoSheet) {
            TradeInfoSheet(firm: firm, trade: trade)
        }
    }
}

#Preview {
    let trade = Trade(
        id: 1949646815,
        symbolId: "F.US.ENQ",
        contractId: "CON.F.US.ENQ.H26",
        accountId: 16046342,
        createdAt: "2026-01-19T17:19:12.118432+00:00",
        tradeDay: "2026-01-19T06:00:00+00:00",
        exitedAt: "2026-01-19T17:20:11.093067+00:00",
        entryPrice: 25386.500000000,
        exitPrice: 25393.750000000,
        fees: 14.00000,
        pnL: 725.000000000,
        positionSize: -5,
        voided: false,
        tradeDuration: "00:00:58.9746350",
        tradeDurationDisplay: "00:00:58"
    )
    OriginCard {
        TradeTile(firm: .topstep, trade: trade, tappable: true)
    }
    .padding()
}
