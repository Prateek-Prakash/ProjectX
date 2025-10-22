//
//  BackupsView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/21/25.
//

import SwiftData
import SwiftUI

struct BackupsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: \RawBackup.id) var rawLogs: [RawBackup]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                if !rawLogs.isEmpty {
                    ScrollView {
                        VStack {
                            
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                } else {
                    ContentUnavailableView {
                        Label("NO BACKUPS", systemImage: "exclamationmark.triangle")
                            .imageScale(.small)
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .tracking(2)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
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
                    Text("BACKUPS")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90")
                            .imageScale(.small)
                            .padding()
                    }
                    .buttonStyle(.plain)
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }
}

