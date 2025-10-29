//
//  AutomationView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/5/25.
//

import SwiftUI

struct AutomationView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
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
                                    Text("POLICIES")
                                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                        .tracking(2)
                                        .foregroundStyle(Color(.xHeaderText))
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                VStack(spacing: 0) {
                                    ForEach(Firm.allCases) { firm in
                                        GroupBox {
                                            HStack {
                                                Text(firm.rawValue)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Image(systemName: firm.automationType.icon)
                                                    .foregroundStyle(firm.automationType.color)
                                                    .fontDesign(.rounded)
                                                    .imageScale(.medium)
                                            }
                                            .frame(height: 12)
                                        }
                                        .backgroundStyle(Color(.xCardBackground))
                                        
                                        if Firm.allCases.last != firm {
                                            Divider()
                                                .frame(height: 1)
                                                .overlay(Color(.xOutline))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .scrollIndicators(.never)
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("AUTOMATION")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
    }
}
