//
//  TradeInfoSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/1/26.
//

import SwiftUI

struct TradeInfoSheet: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let trade: Trade
    
    @State var sheetHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !globalVM.glassSheets {
                    Color(.xCardBackground)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    OriginCard {
                        TradeTile(trade: trade, tappable: false)
                    }
                    
                    OriginCard {
                        GroupBox {
                            HStack {
                                Text("Points")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                Text(abs(trade.exitPrice - trade.entryPrice).asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : 2))
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundStyle((trade.exitPrice - trade.entryPrice) * (trade.positionSize < 0 ? 1 : -1) > 0 ? .green : (trade.exitPrice - trade.entryPrice) < 0 ? .red : .secondary)
                            }
                            .frame(height: 12)
                        }
                        .backgroundStyle(Color(.xCardBackground))
                    }
                    
                    OriginCard {
                        GroupBox {
                            HStack {
                                Text("Duration")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                Text(trade.tradeDurationDisplay)
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(height: 12)
                        }
                        .backgroundStyle(Color(.xCardBackground))
                    }
                    
                    OriginCard {
                        VStack(spacing: 0) {
                            OriginHeader {
                                Text("RUN-UP")
                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundStyle(Color(.xHeaderText))
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            VStack(spacing: 0) {
                                GroupBox {
                                    HStack {
                                        Text("Points")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(0.asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : 2))
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("Dollars")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(0.0.asCurrency())
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                    }
                    
                    OriginCard {
                        VStack(spacing: 0) {
                            OriginHeader {
                                Text("DRAWDOWN")
                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundStyle(Color(.xHeaderText))
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            VStack(spacing: 0) {
                                GroupBox {
                                    HStack {
                                        Text("Points")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(0.asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : 2))
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("Dollars")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(0.0.asCurrency())
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.vertical)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { size in
                    sheetHeight = size.height
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true).toolbar {
                ToolbarItem(placement: .title) {
                    Text("TRADE INFO")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
        .presentationDetents([.height(sheetHeight)])
    }
}
