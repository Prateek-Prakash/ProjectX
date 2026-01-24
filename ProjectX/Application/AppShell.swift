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
    
    @State var showSettingsCover: Bool = false
    @State var successHaptic: Bool = false
    
    @State var screenshotImage: UIImage? = nil
    
    let oneSecondTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let twoSecondTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !globalVM.isInitialized {
                    ProgressView()
                } else if !globalVM.allAccounts.isEmpty {
                    ScrollView {
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
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                } else {
                    
                    ContentUnavailableView {
                        Label("NO ACCOUNTS", systemImage: "exclamationmark.triangle")
                            .imageScale(.small)
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettingsCover.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .imageScale(.small)
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("DASHBOARD")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(
                            item: prepareExport(),
                            preview: SharePreview("", image: renderAsImage())
                        ) {
                            Image(systemName: "square.and.arrow.up")
                                .imageScale(.small)
                        }
                }
                .sharedBackgroundVisibility(.hidden)
            }
            .fullScreenCover(isPresented: $showSettingsCover) {
                SettingsView()
            }
            .onReceive(oneSecondTimer) { _ in
                if globalVM.isInitialized {
                    globalVM.inTradingHours = !globalVM.isMarketClosed()
                }
            }
            .onReceive(twoSecondTimer) { _ in
                if globalVM.isInitialized {
                    Task {
                        await globalVM.refreshData()
                    }
                }
            }
            .overlay {
                if let screenshotImage = screenshotImage {
                    Image(uiImage: screenshotImage)
                }
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { size in
                viewWidth = size.width
            }
        }
    }
    
    @MainActor
    private func prepareExport() -> ExportableImage {
        let imageRenderer = ImageRenderer(content: createScreenshot())
        imageRenderer.scale = displayScale
        imageRenderer.proposedSize = ProposedViewSize(width: viewWidth, height: nil)
        return ExportableImage(uiImage: imageRenderer.uiImage ?? UIImage(), fileName: "Stats-\(Int(Date.now.timeIntervalSince1970))")
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
            .padding()
        }
        .environment(\.colorScheme, colorScheme)
        .environment(\.dynamicTypeSize, dynamicTypeSize)
        .environment(\.displayScale, displayScale)
    }
}

#Preview {
    AppShell()
}
