//
//  DailyStatsInfoSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/14/26.
//

import SwiftUI

struct DailyStatsInfoSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.displayScale) var displayScale
    @State private var viewWidth: CGFloat = 0
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let stats: DailyStats
    
    @State var sheetHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !globalVM.glassSheets {
                    Color(.xCardBackground)
                        .edgesIgnoringSafeArea(.all)
                }
                mainContent()
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
                    Text("DAILY STATS INFO")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ShareLink(item: prepareExport(forTrades: false), preview: SharePreview("", image: renderAsImage(forTrades: false))) {
                            Label("Share Stats", systemImage: "waveform.path.ecg.text.clipboard")
                        }
                        
                        ShareLink(item: prepareExport(forTrades: true), preview: SharePreview("", image: renderAsImage(forTrades: true))) {
                            Label("Share Trades", systemImage: "list.bullet.clipboard")
                        }
                        
                        Button {
                            HapticViewModel.shared.successHaptic()
                            UIPasteboard.general.string = globalVM.exportTradesJson(stats.tradeDate)
                        } label: {
                            Label("Export Trades", systemImage: "document.on.document")
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .imageScale(.medium)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
        .presentationDetents([.height(sheetHeight)])
    }
    
    // MARK: Main Content
    
    func mainContent() -> some View {
        VStack {
            OriginCard {
                GroupBox {
                    HStack {
                        Text("Date")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                        Spacer()
                        Text(stats.tradeDate.asDate())
                            .font(.system(size: 12, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .frame(height: 12)
                }
                .backgroundStyle(Color(.xCardBackground))
            }
            
            OriginCard {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        GroupBox {
                            HStack {
                                Text("Realized P&L")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                let direction = (stats.totalPnL - stats.totalFees) >= 0 ? "+" : "-"
                                Text(stats.totalTrades > 0 ? "\(direction)\(abs(stats.totalPnL - stats.totalFees).asCurrency())" : "--")
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
                                Text("Total Fees")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                Text(stats.totalTrades > 0 ? "-\(abs(stats.totalFees).asCurrency())" : "--")
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
                    VStack(spacing: 0) {
                        GroupBox {
                            HStack {
                                Text("Total Trades")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                Text(String(stats.totalTrades))
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
                                Text("Winning Trades")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                Text(String(stats.winningTrades))
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
                                Text("Losing Trades")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                Text(String(stats.losingTrades))
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
                    VStack(spacing: 0) {
                        GroupBox {
                            HStack {
                                Text("Largest Winner")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                if !globalVM.loadingStatsInfo {
                                    Text(globalVM.statsWinner != nil ? "+\(abs(globalVM.statsWinner!).asCurrency())" : "--")
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
                                Text("Largest Loser")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                if !globalVM.loadingStatsInfo {
                                    Text(globalVM.statsLoser != nil ? "-\(abs(globalVM.statsLoser!).asCurrency())" : "--")
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
                                Text("Max Drawdown")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                Spacer()
                                if !globalVM.loadingStatsInfo {
                                    Text(globalVM.statsDrawdown != nil ? "-\(abs(globalVM.statsDrawdown!).asCurrency())" : "--")
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
    }
    
    // MARK: Export
    
    @MainActor
    private func prepareExport(forTrades: Bool) -> ExportableImage {
        let imageRenderer = ImageRenderer(content: createScreenshot(forTrades: forTrades))
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return ExportableImage(uiImage: imageRenderer.uiImage ?? UIImage(), fileName: "TradeInfo-\(Int(Date.now.timeIntervalSince1970))")
    }
    
    @MainActor
    private func renderAsImage(forTrades: Bool) -> Image {
        let imageRenderer = ImageRenderer(content: createScreenshot(forTrades: forTrades))
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return Image(uiImage: imageRenderer.uiImage ?? UIImage())
    }
    
    func createScreenshot(forTrades: Bool) -> some View {
        ZStack {
            Color(.xBackground)
                .edgesIgnoringSafeArea(.all)
            if forTrades {
                OriginCard {
                    VStack(spacing: 0) {
                        let trades = globalVM.accountTrades.filter({ $0.tradeDay == stats.tradeDate }).reversed()
                        ForEach(trades) { trade in
                            HStack {
                                VStack(alignment: .center) {
                                    Text(abs(trade.pnL).asCurrency())
                                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                        .foregroundStyle(trade.pnL > 0.0 ? .green : trade.pnL < 0.0 ? .red : .secondary)
                                    Text("P&L")
                                        .font(.system(size: 8, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .center) {
                                    Text(abs(trade.fees).asCurrency())
                                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                        .foregroundStyle(.red)
                                    Text("FEES")
                                        .font(.system(size: 8, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .center) {
                                    let runUp = globalVM.runUpDollarsMap[globalVM.selectedAccount!.firm]![trade.ref]
                                    Text(runUp != nil ? abs(runUp!).asCurrency() : "--")
                                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                        .foregroundStyle(.green)
                                    Text("RUN-UP")
                                        .font(.system(size: 8, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(alignment: .center) {
                                    let drawdown = globalVM.drawdownDollarsMap[globalVM.selectedAccount!.firm]![trade.ref]
                                    Text(drawdown != nil ? abs(drawdown!).asCurrency() : "--")
                                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                        .foregroundStyle(drawdown != nil ? drawdown != 0.0 ? .red : .secondary : .secondary)
                                    Text("DRAWDOWN")
                                        .font(.system(size: 8, design: .monospaced))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.all, 14)
                            
                            if trades.last != trade {
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                            }
                        }
                    }
                }
                .padding()
            } else {
                mainContent()
                    .padding()
            }
        }
        .environment(\.colorScheme, colorScheme)
        .environment(\.dynamicTypeSize, dynamicTypeSize)
        .environment(\.displayScale, displayScale)
    }
}
