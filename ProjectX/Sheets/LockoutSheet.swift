//
//  LockoutSheet.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/17/26.
//

import SwiftUI

struct LockoutSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var sheetHeight: CGFloat = 0
    
    let account: Account
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !globalVM.glassSheets {
                    Color(.xCardBackground)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    Button {
                        Task {
                            let start = Date.now
                            let end = Date.now.addingTimeInterval(60 * 15)
                            await globalVM.lockAccount(account, start, end)
                        }
                        dismiss()
                    } label: {
                        ZStack {
                            Color.clear
                                .ignoresSafeArea(.all)
                            Text("15 MINUTES")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(.primary)
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity)
                        }
                        .contentShape(.rect)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.primary, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        Task {
                            let start = Date.now
                            let end = Date.now.addingTimeInterval(60 * 30)
                            await globalVM.lockAccount(account, start, end)
                        }
                        dismiss()
                    } label: {
                        ZStack {
                            Color.clear
                                .ignoresSafeArea(.all)
                            Text("30 MINUTES")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(.primary)
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity)
                        }
                        .contentShape(.rect)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.primary, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        Task {
                            let start = Date.now
                            let end = Date.now.addingTimeInterval(60 * 60)
                            await globalVM.lockAccount(account, start, end)
                        }
                        dismiss()
                    } label: {
                        ZStack {
                            Color.clear
                                .ignoresSafeArea(.all)
                            Text("1 HOUR")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(.primary)
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity)
                        }
                        .contentShape(.rect)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.primary, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        Task {
                            let start = Date.now
                            if let next = Date.now.nextOccurrence(ofHour: 17) {
                                let end = next.addingTimeInterval(60 * 15)
                                await globalVM.lockAccount(account, start, end)
                            }
                        }
                        dismiss()
                    } label: {
                        ZStack {
                            Color.clear
                                .ignoresSafeArea(.all)
                            Text("ALL DAY")
                                .font(.system(size: 10, weight: .semibold, design: .rounded))
                                .foregroundStyle(.primary)
                                .padding(.all, 14)
                                .frame(maxWidth: .infinity)
                        }
                        .contentShape(.rect)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.primary, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        Task {
                            // TODO: Implement
                        }
                        dismiss()
                    } label: {
                        ZStack {
                            Color.primary
                                .ignoresSafeArea(.all)
                            Text("CUSTOM")
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
                    .disabled(true) // TODO: Enable
                    
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
            }
            .onGeometryChange(for: CGSize.self) {
                $0.size
            } action: { size in
                sheetHeight = size.height
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true).toolbar {
                ToolbarItem(placement: .title) {
                    Text("LOCKOUT")
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
        }
        .presentationDetents([.height(sheetHeight)])
        .interactiveDismissDisabled()
    }
}
