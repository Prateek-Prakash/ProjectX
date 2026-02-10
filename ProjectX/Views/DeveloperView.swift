//
//  DeveloperView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SignalRClient
import SwiftUI

struct DeveloperView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    @StateObject var audioVM = AudioViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 10) {
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
                                        // TODO: Select Streaming Source
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Streaming Source")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.streamingSource.rawValue)
                                                    .font(.system(size: 12, design: .rounded))
                                                    .foregroundStyle(.secondary)
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.secondary)
                                                    .fontDesign(.rounded)
                                                    .imageScale(.small)
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
                                    
                                    if globalVM.priceStreaming {
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("NQ")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.nqPrice?.asPoints(2) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("MNQ")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.mnqPrice?.asPoints(2) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("ES")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.esPrice?.asPoints(2) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("MES")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.mesPrice?.asPoints(2) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("GC")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.gcPrice?.asPoints(1) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("MGC")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.mgcPrice?.asPoints(1) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("SI")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.siPrice?.asPoints(3) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                        
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                        
                                        GroupBox {
                                            HStack {
                                                Image(systemName: "text.page")
                                                    .imageScale(.small)
                                                Text("SIL")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(globalVM.silPrice?.asPoints(3) ?? "--")
                                                    .font(.system(size: 12, design: .monospaced))
                                                    .foregroundStyle(.secondary)
                                            }
                                            .frame(height: 12)
                                        }
                                    }
                                }
                                .backgroundStyle(Color(.xCardBackground))
                            }
                        }
                        
                        OriginCard {
                            VStack(spacing: 0) {
                                OriginHeader {
                                    Text("AUDIO TWEAKING")
                                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                        .tracking(2)
                                        .foregroundStyle(Color(.xHeaderText))
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("Voice Rate")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Slider(value: $audioVM.speechRate, in: 0.0...1.0, step: 0.1)
                                            .scaleEffect(0.6, anchor: .trailing)
                                            .frame(maxWidth: 250)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
//                                .onChange(of: audioVM.speechRate) {
//                                    audioVM.speakText("VOICE UPDATED")
//                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("Voice Pitch")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Slider(value: $audioVM.speechPitch, in: 0.5...2.0, step: 0.25)
                                            .scaleEffect(0.6, anchor: .trailing)
                                            .frame(maxWidth: 250)
                                    }
                                    .frame(height: 12)
                                }
                                .backgroundStyle(Color(.xCardBackground))
//                                .onChange(of: audioVM.speechPitch) {
//                                    audioVM.speakText("VOICE UPDATED")
//                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                Button {
                                    audioVM.speakText("Entered-Position")
                                } label: {
                                    GroupBox {
                                        HStack {
                                            Text("Entered Position")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Image(systemName: "speaker.wave.2.fill")
                                                .foregroundStyle(.secondary)
                                                .fontDesign(.rounded)
                                                .imageScale(.small)
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
                                    audioVM.speakText("Exited-Position")
                                } label: {
                                    GroupBox {
                                        HStack {
                                            Text("Exited Position")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Image(systemName: "speaker.wave.2.fill")
                                                .foregroundStyle(.secondary)
                                                .fontDesign(.rounded)
                                                .imageScale(.small)
                                        }
                                        .frame(height: 12)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                }
                                .buttonStyle(.plain)
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                VStack(spacing: 0) {
                                    Button {
                                        audioVM.speakText("Entered-Short")
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Entered Short")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Image(systemName: "speaker.wave.2.fill")
                                                    .foregroundStyle(.secondary)
                                                    .fontDesign(.rounded)
                                                    .imageScale(.small)
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
                                        audioVM.speakText("Exited-Short")
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Exited Short")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Image(systemName: "speaker.wave.2.fill")
                                                    .foregroundStyle(.secondary)
                                                    .fontDesign(.rounded)
                                                    .imageScale(.small)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                    }
                                    .buttonStyle(.plain)
                                }
                                .backgroundStyle(Color(.xCardBackground))
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                Button {
                                    audioVM.speakText("Entered-Long")
                                } label: {
                                    GroupBox {
                                        HStack {
                                            Text("Entered Long")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Image(systemName: "speaker.wave.2.fill")
                                                .foregroundStyle(.secondary)
                                                .fontDesign(.rounded)
                                                .imageScale(.small)
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
                                    audioVM.speakText("Exited-Long")
                                } label: {
                                    GroupBox {
                                        HStack {
                                            Text("Exited Long")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Image(systemName: "speaker.wave.2.fill")
                                                .foregroundStyle(.secondary)
                                                .fontDesign(.rounded)
                                                .imageScale(.small)
                                        }
                                        .frame(height: 12)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                }
                                .buttonStyle(.plain)
                            }
                            .backgroundStyle(Color(.xCardBackground))
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
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                    
                                    Button {
                                        globalVM.delayTradeInfo.toggle()
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Delay Trade Info")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Toggle("", isOn: $globalVM.delayTradeInfo)
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
                                        globalVM.delaySymbolBlocks.toggle()
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text("Delay Symbol Blocks")
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Toggle("", isOn: $globalVM.delaySymbolBlocks)
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
                                HapticViewModel.shared.successHaptic()
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
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
            .onChange(of: globalVM.priceStreaming) {
                if !globalVM.priceStreaming {
                    Task {
                        await globalVM.marketCtx?.stop()
                        globalVM.marketCtx = nil
                        globalVM.nqPrice = nil
                        globalVM.mnqPrice = nil
                        globalVM.esPrice = nil
                        globalVM.mesPrice = nil
                        globalVM.gcPrice = nil
                        globalVM.mgcPrice = nil
                        globalVM.siPrice = nil
                        globalVM.silPrice = nil
                    }
                } else {
                    Task {
                        await globalVM.initMarketSignals()
                    }
                }
            }
        }
    }
}

#Preview {
    DeveloperView()
}
