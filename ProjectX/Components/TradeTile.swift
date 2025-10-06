//
//  TradeTile.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/19/25.
//

import SwiftUI

struct TradeTile: View {
    let trade: Trade
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: trade.positionSize < 0 ? "arrowtriangle.up.fill" : trade.positionSize > 0 ? "arrowtriangle.down.fill" : "questionmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(trade.positionSize < 0 ? .green : trade.positionSize > 0 ? .red : .primary)
                Text(contractMap[trade.symbolId] ?? "--")
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
                Text(trade.entryPrice.asCurrency())
                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                Text(trade.createdAt.asDate())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
                Text(trade.createdAt.asTime())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                Text(trade.exitPrice.asCurrency())
                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                Text(trade.exitedAt.asDate())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
                Text(trade.exitedAt.asTime())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(abs(trade.pnL).asCurrency())
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundStyle(trade.pnL > 0 ? .green.mix(with: .white, by: 0.2) : trade.pnL < 0 ? .red.mix(with: .white, by: 0.2) : .gray.mix(with: .white, by: 0.2))
                    Text(trade.fees.asCurrency())
                        .font(.system(size: 8, design: .monospaced))
                        .foregroundStyle(.red.mix(with: .white, by: 0.2))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.all, 14)
    }
}

