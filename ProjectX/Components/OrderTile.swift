//
//  OrderTile.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/19/25.
//

import SwiftUI

struct OrderTile: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let account: Account
    let order: Order
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: order.tagString != nil ? "circle.fill" : "circle")
                    .resizable()
                    .frame(width: 6, height: 6)
                    .foregroundStyle(Color.fromString(order.tagString))
                Text(globalVM.getTickerId(account.firm, order.symbolId))
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                Spacer()
            }
            .frame(width: 50)
            
            VStack {
                Text(String(abs(order.size)))
                    .font(.system(size: 10, design: .monospaced))
            }
            .frame(width: 20)
            
            VStack(alignment: .center) {
                Text(order.points?.asPoints(globalVM.getTickerDigits(account.firm, order.symbolId)) ?? "--")
                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                Text(order.ordeType.uppercased())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                Text(order.updateTimestamp.asFractionalDate())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
                Text(order.updateTimestamp.asFractionalTime())
                    .font(.system(size: 8, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Button {
                HapticViewModel.shared.successHaptic()
                Task {
                    let _ = await XClient.get(account.firm).cancelOrder(account.id, order.id)
                }
            } label: {
                Image(systemName: "trash.fill")
                    .imageScale(.small)
                    .foregroundStyle(.red)
            }
        }
        .padding(.all, 14)
        .contentShape(.rect)
    }
}
