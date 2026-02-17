//
//  AppShell.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import Combine
import SwiftData
import SwiftUI

struct AppShell: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @Environment(\.displayScale) var displayScale
    @State private var viewWidth: CGFloat = 0
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\RawBackup.firm), SortDescriptor(\RawBackup.name)]) var rawBackups: [RawBackup]
    
    @State var showCustomizationSheet: Bool = false
    @State var showSettingsCover: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !globalVM.isInitialized {
                    ProgressView()
                } else if !globalVM.allAccounts.isEmpty {
                    ScrollView {
                        mainContent()
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                } else {
                    emptyContent()
                        .padding()
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .title) {
                    Text("DASHBOARD")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showCustomizationSheet.toggle()
                        } label: {
                            Label("Customization", systemImage: "theatermask.and.paintbrush")
                        }
                        
                        Button {
                            HapticViewModel.shared.errorHaptic()
                            Task {
                                await backupAccounts()
                            }
                        } label: {
                            Label("Backup", systemImage: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                        }
                        
                        ShareLink(item: prepareExport(), preview: SharePreview("", image: renderAsImage())) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button {
                            showSettingsCover.toggle()
                        } label: {
                            Label("Settings", systemImage: "gearshape")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .imageScale(.medium)
                    }
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .fullScreenCover(isPresented: $showSettingsCover) {
                SettingsView()
            }
            .sheet(isPresented: $showCustomizationSheet) {
                CustomizationSheet()
            }
            .onReceive(globalVM.marketTimer) { _ in
                if globalVM.isInitialized {
                    globalVM.inTradingHours = !globalVM.isMarketClosed()
                }
            }
            .onReceive(globalVM.refreshTimer) { _ in
                if globalVM.isInitialized {
                    Task {
                        await globalVM.refreshData()
                    }
                }
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { size in
                viewWidth = size.width
            }
        }
        .sensoryFeedback(.success, trigger: HapticViewModel.shared.success)
        .sensoryFeedback(.error, trigger: HapticViewModel.shared.error)
        .sensoryFeedback(.selection, trigger: HapticViewModel.shared.selection)
    }
    
    // MARK: Main Content
    
    func mainContent() -> some View {
        VStack(spacing: 10) {
            ForEach(Firm.allCases) { firm in
                if globalVM.isLinked(firm) && globalVM.isConnected(firm) {
                    let accounts = globalVM.allAccounts.filter({
                        $0.firm == firm
                        && ((globalVM.showEvaluationAccounts && $0.accountType == .evaluation) || (globalVM.showFundedAccounts && $0.accountType == .funded) || (globalVM.showPracticeAccounts && $0.accountType == .practice))
                        && ((globalVM.hideLockedAccounts && $0.canTrade) || !globalVM.hideLockedAccounts)
                    })
                    if !globalVM.hideEmptyFirms || !accounts.isEmpty {
                        FirmCard(
                            firm: firm,
                            accounts: accounts
                        )
                    }
                }
            }
        }
    }
    
    func emptyContent() -> some View {
        ContentUnavailableView {
            Label("NO ACCOUNTS FOUND", systemImage: "exclamationmark.triangle")
                .imageScale(.small)
                .font(.system(size: 8, weight: .semibold, design: .monospaced))
                .tracking(2)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: Export
    
    @MainActor
    private func prepareExport() -> ExportableImage {
        let imageRenderer = ImageRenderer(content: createScreenshot())
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return ExportableImage(uiImage: imageRenderer.uiImage ?? UIImage(), fileName: "\(Int(Date.now.timeIntervalSince1970))")
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
            if !globalVM.isInitialized {
                ProgressView()
                    .padding()
            } else if !globalVM.allAccounts.isEmpty {
                mainContent()
                    .padding()
            } else {
                emptyContent()
                    .padding()
            }
        }
        .environment(\.colorScheme, colorScheme)
        .environment(\.dynamicTypeSize, dynamicTypeSize)
        .environment(\.displayScale, displayScale)
    }
    
    // MARK: Backup
    
    func backupAccounts() async {
        for account in globalVM.allAccounts {
            let existing = rawBackups.first(where: { $0.firm == account.firm.headerName && $0.name == account.accountName })
            
            let trades = await XClient.get(account.firm).getTrades(account.accountId)
            if !trades.isEmpty {
                let encoder = JSONEncoder()
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                let data = try! encoder.encode(trades)
                let json = String(data: data, encoding: .utf8)!
                
                if existing != nil {
                    existing?.update(json)
                } else {
                    let backup = RawBackup(
                        firm: account.firm.headerName,
                        name: account.accountName,
                        json: json,
                        timestamp: Date.now.ISO8601Format()
                    )
                    modelContext.insert(backup)
                }
            }
        }
        try? modelContext.save()
    }
}

#Preview {
    AppShell()
}
