//
//  DeveloperView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SignalRClient
import SwiftUI

struct DeveloperView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var successHaptic: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        OriginCard {
                            VStack(spacing: 0) {
                                OriginHeader {
                                    Text("MARKET STATUS")
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
                                            Text("Next Open")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Text(globalVM.nextMarketOpen)
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
                                            Text("Next Close")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Text(globalVM.nextMarketClose)
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
                                    Text("STREAMING")
                                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                        .tracking(2)
                                        .foregroundStyle(Color(.xHeaderText))
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                VStack(spacing: 0) {
                                    Button {
                                        globalVM.priceStreaming.toggle()
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Price Streaming")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Toggle("", isOn: $globalVM.priceStreaming)
                                                    .scaleEffect(0.6, anchor: .trailing)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    GroupBox {
                                        HStack {
                                            Text("MNQ Price")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Text(globalVM.mnqPrice?.asCurrency() ?? "--")
                                                .font(.system(size: 12, design: .rounded))
                                                .foregroundStyle(.secondary)
                                        }
                                        .frame(height: 12)
                                    }
                                    .onChange(of: globalVM.priceStreaming) {
                                        if !globalVM.priceStreaming {
                                            Task {
                                                await globalVM.marketCtx?.stop()
                                                globalVM.marketCtx = nil
                                                globalVM.mnqPrice = nil
                                            }
                                        } else {
                                            Task {
                                                await globalVM.initMarketSignals(.topstep)
                                            }
                                        }
                                    }
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                        }
                        
                        OriginCard {
                            VStack(spacing: 0) {
                                OriginHeader {
                                    Text("ANIMATION DEBUGGING")
                                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                        .tracking(2)
                                        .foregroundStyle(Color(.xHeaderText))
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                VStack(spacing: 0) {
                                    Button {
                                        globalVM.delayAuthentication.toggle()
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Delay Authentication")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Toggle("", isOn: $globalVM.delayAuthentication)
                                                    .scaleEffect(0.6, anchor: .trailing)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    Button {
                                        globalVM.delayLoadingTrades.toggle()
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Delay Loading Trades")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Toggle("", isOn: $globalVM.delayLoadingTrades)
                                                    .scaleEffect(0.6, anchor: .trailing)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                        }
                        
                        OriginCard {
                            Button {
                                globalVM.automaticRefresh.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Automatic Refresh")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.automaticRefresh)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        OriginCard {
                            Button {
                                globalVM.automaticBackup.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Automatic Backup")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.automaticBackup)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        OriginCard {
                            Button {
                                globalVM.executeLockouts.toggle()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Execute Lockouts")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Toggle("", isOn: $globalVM.executeLockouts)
                                            .scaleEffect(0.6, anchor: .trailing)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        OriginCard {
                            Button {
                                successHaptic.toggle()
                                globalVM.clearOldIds()
                            } label: {
                                GroupBox {
                                    HStack {
                                        Text("Clear Old IDs")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundStyle(.red)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.red.secondary)
                                            .fontDesign(.rounded)
                                            .imageScale(.small)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                            .buttonStyle(.plain)
                            .sensoryFeedback(.success, trigger: successHaptic)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("DEVELOPER")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
