//
//  ContractsSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/18/26.
//

import SwiftUI

struct ContractsSheet: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !globalVM.glassSheets {
                    Color(.xCardBackground)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.vertical)
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true).toolbar {
                ToolbarItem(placement: .title) {
                    Text("CONTRACTS")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
