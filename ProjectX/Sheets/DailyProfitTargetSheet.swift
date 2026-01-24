//
//  DailyProfitTargetSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/20/25.
//

import SwiftUI

struct DailyProfitTargetSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var sheetHeight: CGFloat = 0
    
    @FocusState var isFocused: Bool
    @State var dailyProfitTarget: String = ""
    @State var limitAction: Int = 0
    
    let account: Account
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xCardBackground)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Picker("Limit Action", selection: $limitAction) {
                        Text("Nothing").tag(0)
                        Text("Liquidate").tag(1)
                        Text("Block").tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    OriginCard {
                        TextField("Daily Profit Target", text: $dailyProfitTarget)
                            .padding(.all, 14)
                            .keyboardType(.numberPad)
                            .focused($isFocused)
                    }
                    
                    Button {
                        Task {
                            let _ = await XClient.get(account.firm).setPersonalLimits(account.accountId, dailyProfitTarget.isEmpty ? 0 : Int(dailyProfitTarget), dailyProfitTarget.isEmpty ? 0 : limitAction, account.personalDailyLossLimit, account.personalDailyLossLimitAction, account.personalDailyLossLimitTrailing)
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
                        Text("DAILY PROFIT TARGET")
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
