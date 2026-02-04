//
//  PositionTile.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/19/26.
//

import SwiftUI

struct PositionTile: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let position: Position
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: position.type == 1 ? "arrowtriangle.up.fill" : position.type == 2 ? "arrowtriangle.down.fill" : "questionmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(position.type == 1 ? .green : position.type == 2 ? .red : .primary)
                Text(contractMap[position.symbolId] ?? "--")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .center) {
                Text(String(abs(position.size)))
                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                Text("CONTRACTS")
                    .font(.system(size: 6, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(position.averagePrice.asPoints(globalVM.getTickerDigits(position.symbolId)))
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.all, 14)
    }
}

#Preview {
    let position = Position(
        id: 530348194,
        accountId: 16945931,
        contractId: "CON.F.US.MNQ.H26",
        symbolId: "F.US.MNQ",
        creationTimestamp: "2026-01-19T00:17:12.460036+00:00",
        type: 1,
        size: 5,
        averagePrice: 25441.250000000
    )
    OriginCard {
        PositionTile(position: position)
    }
    .padding()
}
