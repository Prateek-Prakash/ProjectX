//
//  CredentialsView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 9/19/25.
//

import SwiftUI

struct CredentialsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var sheetHeight: CGFloat = 0
    
    let firm: Firm
    
    var body: some View {
        ZStack {
            Color(.xCardBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                OriginCard {
                    TextField("Username", text: $globalVM.usernameInput)
                        .padding(.all, 14)
                }
                OriginCard {
                    SecureField("API Key", text: $globalVM.keyInput)
                        .padding(.all, 14)
                }
                
                Button {
                    Task {
                        await globalVM.saveCredentials(firm)
                    }
                    dismiss()
                } label: {
                    ZStack {
                        Color.primary
                            .ignoresSafeArea(.all)
                        Text("SAVE")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color(.xCardBackground))
                            .padding(.all, 14)
                            .frame(maxWidth: .infinity)
                    }
                    .contentShape(.rect)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.xOutline), lineWidth: 1))
                }
                .buttonStyle(.plain)
                
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Text("CANCEL")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundStyle(.red)
                            .padding(.all, 14)
                            .frame(maxWidth: .infinity)
                    }
                    .contentShape(.rect)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.red), lineWidth: 1))
                }
                .buttonStyle(.plain)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .padding(.top)
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { size in
                sheetHeight = size.height
            }
        }
        .presentationDetents([.height(sheetHeight)])
        .interactiveDismissDisabled()
    }
}
