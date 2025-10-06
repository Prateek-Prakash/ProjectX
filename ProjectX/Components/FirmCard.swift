//
//  FirmCard.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import SwiftUI

struct FirmCard: View {
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    let firm: Firm
    let accounts: [Account]
    
    var body: some View {
        OriginCard {
            VStack(spacing: 0) {
                OriginHeader {
                    Text("\(firm.headerName) • \(accounts.count)")
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(Color(.xHeaderText))
                }
                
                Divider()
                    .frame(height: 1)
                    .overlay(Color(.xOutline))
                
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(accounts) { account in
                            if (globalVM.showEvaluationAccounts && account.accountType == .evaluation) || (globalVM.showFundedAccounts && account.accountType == .funded) || (globalVM.showPracticeAccounts && account.accountType == .practice) {
                                AccountTile(account: account, tappable: true)
                                if accounts.last != account {
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color(.xOutline))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
