//
//  TradeInfoSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/1/26.
//

import SwiftUI

struct TradeInfoSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.displayScale) var displayScale
    @State private var viewWidth: CGFloat = 0
    
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
                                Text(abs(trade.exitPrice - trade.entryPrice).asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : ["GC", "MGC"].contains(contractMap[trade.symbolId]) ? 1 : 2))
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
                                        if let runUpPoints = globalVM.runUpPoints {
                                            Text(runUpPoints != -1 ? "+\(runUpPoints.asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : ["GC", "MGC"].contains(contractMap[trade.symbolId]) ? 1 : 2))" : "--")
                                                .font(.system(size: 12, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        } else {
                                            ProgressView()
                                        }
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
                                        if let runUpDollars = globalVM.runUpDollars {
                                            Text(runUpDollars != -1 ? "-\(0.asCurrency())" : "--")
                                                .font(.system(size: 12, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        } else {
                                            ProgressView()
                                        }
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
                                        if let drawdownPoints = globalVM.drawdownPoints {
                                            Text(drawdownPoints != -1 ? "-\(drawdownPoints.asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : ["GC", "MGC"].contains(contractMap[trade.symbolId]) ? 1 : 2))" : "--")
                                                .font(.system(size: 12, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        } else {
                                            ProgressView()
                                        }
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
                                        if let drawdownDollars = globalVM.drawdownDollars {
                                            Text(drawdownDollars != -1 ? "-\(0.asCurrency())" : "--")
                                                .font(.system(size: 12, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        } else {
                                            ProgressView()
                                        }
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
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { size in
                sheetHeight = size.height
                viewWidth = size.width
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("TRADE INFO")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: prepareExport(), preview: SharePreview("", image: renderAsImage())) {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.small)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        .presentationDetents([.height(sheetHeight)])
    }
    
    // MARK: Export
    
    @MainActor
    private func prepareExport() -> ExportableImage {
        let imageRenderer = ImageRenderer(content: createScreenshot())
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return ExportableImage(uiImage: imageRenderer.uiImage ?? UIImage(), fileName: "TradeInfo-\(Int(Date.now.timeIntervalSince1970))")
    }
    
    @MainActor
    private func renderAsImage() -> Image {
        let imageRenderer = ImageRenderer(content: createScreenshot())
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return Image(uiImage: imageRenderer.uiImage ?? UIImage())
    }
    
    func createScreenshot() -> some View {
        ZStack {
            Color(.xBackground)
                .edgesIgnoringSafeArea(.all)
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
                            Text(abs(trade.exitPrice - trade.entryPrice).asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : ["GC", "MGC"].contains(contractMap[trade.symbolId]) ? 1 : 2))
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
                                    if let runUpPoints = globalVM.runUpPoints {
                                        Text(runUpPoints != -1 ? "+\(runUpPoints.asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : ["GC", "MGC"].contains(contractMap[trade.symbolId]) ? 1 : 2))" : "--")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    } else {
                                        ProgressView()
                                    }
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
                                    if let runUpDollars = globalVM.runUpDollars {
                                        Text(runUpDollars != -1 ? "-\(0.asCurrency())" : "--")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    } else {
                                        ProgressView()
                                    }
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
                                    if let drawdownPoints = globalVM.drawdownPoints {
                                        Text(drawdownPoints != -1 ? "-\(drawdownPoints.asPoints(["SI", "SIL"].contains(contractMap[trade.symbolId]) ? 3 : ["GC", "MGC"].contains(contractMap[trade.symbolId]) ? 1 : 2))" : "--")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    } else {
                                        ProgressView()
                                    }
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
                                    if let drawdownDollars = globalVM.drawdownDollars {
                                        Text(drawdownDollars != -1 ? "-\(0.asCurrency())" : "--")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    } else {
                                        ProgressView()
                                    }
                                }
                                .frame(height: 12)
                            }
                        }
                        .backgroundStyle(Color(.xCardBackground))
                    }
                }
            }
            .padding()
        }
        .environment(\.colorScheme, colorScheme)
        .environment(\.dynamicTypeSize, dynamicTypeSize)
        .environment(\.displayScale, displayScale)
    }
}
