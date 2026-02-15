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
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("Max Drawdown")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(stats.totalTrades > 0 ? "-\(abs(globalVM.statsDrawdown).asCurrency())" : "--")
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
                                        Text(stats.totalTrades > 0 ? "+\(abs(globalVM.statsWinner).asCurrency())" : "--")
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
                                        Text("Largest Loser")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(stats.totalTrades > 0 ? "-\(abs(globalVM.statsLoser).asCurrency())" : "--")
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
                        ShareLink(item: prepareExport(), preview: SharePreview("", image: renderAsImage())) {
                            Label("Share Stats", systemImage: "waveform.path.ecg.text.clipboard")
                        }
                        
                        ShareLink(item: prepareExport(), preview: SharePreview("", image: renderAsImage())) {
                            Label("Share Trades", systemImage: "list.bullet.clipboard")
                        }
                        .disabled(true)
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
    
    // MARK: Export
    
    @MainActor
    private func prepareExport() -> ExportableImage {
        let imageRenderer = ImageRenderer(content: createScreenshot())
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return ExportableImage(uiImage: imageRenderer.uiImage ?? UIImage(), fileName: "DailyStatsInfo-\(Int(Date.now.timeIntervalSince1970))")
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
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            GroupBox {
                                HStack {
                                    Text("Max Drawdown")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text(stats.totalTrades > 0 ? "-\(abs(globalVM.statsDrawdown).asCurrency())" : "--")
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
                                    Text(stats.totalTrades > 0 ? "+\(abs(globalVM.statsWinner).asCurrency())" : "--")
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
                                    Text("Largest Loser")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text(stats.totalTrades > 0 ? "-\(abs(globalVM.statsLoser).asCurrency())" : "--")
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
            .padding()
        }
        .environment(\.colorScheme, colorScheme)
        .environment(\.dynamicTypeSize, dynamicTypeSize)
        .environment(\.displayScale, displayScale)
    }
}
