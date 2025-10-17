//
//  CloseButton.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/19/25.
//

import SwiftUI

struct CloseButton: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    var body: some View {
        Button {
            dismiss()
            // TODO: PerformanceView Close Only
            globalVM.selectedAccount = nil
            globalVM.accountDailyStats.removeAll()
            globalVM.accountTrades.removeAll()
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .padding()
        }
        .buttonStyle(.plain)
    }
}
