//
//  DonateView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 10/5/25.
//

import SwiftUI

struct DonateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var globalVM = GlobalViewModel.shared
    
    @State var selectedDonation: Donation? = nil
    
    let allDonations = [
        Donation(name: "Buy Me A Coffee", url: URL(string: "https://buymeacoffee.com/teekoder")!),
        Donation(name: "Ko-fi", url: URL(string: "https://ko-fi.com/teekoder")!)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.xBackground)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(allDonations) { donation in
                            OriginCard {
                                Button {
                                    selectedDonation = donation
                                } label: {
                                    GroupBox {
                                        HStack {
                                            Text(donation.name)
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.secondary)
                                                .fontDesign(.rounded)
                                                .imageScale(.small)
                                        }
                                        .frame(height: 12)
                                    }
                                    .backgroundStyle(Color(.xCardBackground))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
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
                    Text("DONATE")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
            .sheet(item: $selectedDonation) {
                SafariView(url: $0.url)
            }
        }
    }
}
