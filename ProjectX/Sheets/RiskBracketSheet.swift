//
//  RiskBracketSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 2/15/26.
//

import SwiftUI

struct RiskBracketSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var sheetHeight: CGFloat = 0
    
    @FocusState var isFocused: Bool
    @State var riskBracket: String = ""
    
    let account: Account
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !globalVM.glassSheets {
                    Color(.xCardBackground)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    OriginCard {
                        TextField("Risk Bracket", text: $riskBracket)
                            .padding(.all, 14)
                            .keyboardType(.numberPad)
                            .focused($isFocused)
                    }
                    
                    Button {
                        Task {
                            let _ = await XClient.get(account.firm).setPositionBrackets(account.accountId, account.bracketAutoApply ?? false, riskBracket.isEmpty ? 0 : Double(riskBracket), account.bracketAmountToMake)
                            dismiss()
                        }
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
                .padding(.vertical)
                .onGeometryChange(for: CGSize.self) {
                    $0.size
                } action: { size in
                    sheetHeight = size.height
                }
                .toolbarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true).toolbar {
                    ToolbarItem(placement: .title) {
                        Text("RISK BRACKET")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .tracking(2)
                    }
                }
            }
            .presentationDetents([.height(sheetHeight)])
            .interactiveDismissDisabled()
        }
    }
}
