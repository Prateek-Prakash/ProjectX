//
//  WinRateView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/23/25.
//

import SwiftUI

struct WinRateView: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    OriginCard {
                        VStack(spacing: 0) {
                            GroupBox {
                                HStack {
                                    Text("Under 15 Seconds")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("15 Seconds - 45 Seconds")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("45 Seconds - 1 Minute")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("1 Minute - 2 Minutes")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("2 Minutes - 5 Minutes")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("5 Minutes - 10 Minutes")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("10 Minutes - 30 Minutes")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("30 Minutes - 1 Hour")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("1 Hour - 2 Hours")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("2 Hours - 4 Hours")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
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
                                    Text("Over 4 Hours")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                    Spacer()
                                    Text("--")
                                        .font(.system(size: 12, design: .rounded))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(height: 12)
                            }
                        }
                        .backgroundStyle(Color(.xCardBackground))
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
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
                Text("WIN RATE")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .tracking(2)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: Filter
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .imageScale(.small)
                        .increaseTapArea(by: 12)
                }
                .buttonStyle(.plain)
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}
