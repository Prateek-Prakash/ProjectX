//
//  DeveloperView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SwiftUI

struct DeveloperView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    OriginCard {
                        Button {
                            globalVM.delayAuthentication.toggle()
                        } label: {
                            GroupBox {
                                HStack {
                                    Text("Delay Authentication")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .fontDesign(.rounded)
                                    Spacer()
                                    Toggle("", isOn: $globalVM.delayAuthentication)
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
                    Text("DEVELOPER")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
