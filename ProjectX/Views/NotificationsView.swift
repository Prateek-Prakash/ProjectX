//
//  NotificationsView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    OriginCard {
                        Button {
                            globalVM.pushNotifications.toggle()
                        } label: {
                            GroupBox {
                                HStack {
                                    Text("Push Notifications")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .fontDesign(.rounded)
                                    Spacer()
                                    Toggle("", isOn: $globalVM.pushNotifications)
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
                            globalVM.liveActivities.toggle()
                        } label: {
                            GroupBox {
                                HStack {
                                    Text("Live Activities")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .fontDesign(.rounded)
                                    Spacer()
                                    Toggle("", isOn: $globalVM.liveActivities)
                                        .scaleEffect(0.6, anchor: .trailing)
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
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("NOTIFICATIONS")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
