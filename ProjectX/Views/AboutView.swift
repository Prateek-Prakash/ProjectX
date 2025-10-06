//
//  AboutView.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/27/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var selected: Dependency?
    
    let dependencies = [
        Dependency(name: "Alamofire", version: "5.10.2", url: URL(string: "https://github.com/Alamofire/Alamofire/tree/5.10.2")!),
        Dependency(name: "SignalRClient", version: "Main", url: URL(string: "https://github.com/dotnet/signalr-client-swift/tree/main")!)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    OriginCard {
                        VStack(spacing: 0) {
                            OriginHeader {
                                Text("APP INFO")
                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundStyle(Color(.xHeaderText))
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            VStack(spacing: 0) {
                                GroupBox {
                                    HStack {
                                        Text("Name")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text("ProjectX")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("Version")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text("1.0.0")
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                    }
                    
                    OriginCard {
                        VStack(spacing: 0) {
                            OriginHeader {
                                Text("DEVICE INFO")
                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundStyle(Color(.xHeaderText))
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            VStack(spacing: 0) {
                                GroupBox {
                                    HStack {
                                        Text("Model")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(UIDevice.current.model)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("System Name")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(UIDevice.current.systemName)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("System Version")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(UIDevice.current.systemVersion)
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                                
                                Divider()
                                    .frame(height: 1)
                                    .overlay(Color(.xOutline))
                                
                                GroupBox {
                                    HStack {
                                        Text("User Interface")
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                        Spacer()
                                        Text(UIDevice.current.userInterfaceIdiom.toString())
                                            .font(.system(size: 12, design: .rounded))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(height: 12)
                                }
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                    }
                    
                    OriginCard {
                        VStack(spacing: 0) {
                            OriginHeader {
                                Text("DEPENDENCIES")
                                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                                    .tracking(2)
                                    .foregroundStyle(Color(.xHeaderText))
                            }
                            
                            Divider()
                                .frame(height: 1)
                                .overlay(Color(.xOutline))
                            
                            VStack(spacing: 0) {
                                ForEach(dependencies) { dependency in
                                    Button {
                                        selected = dependency
                                    } label: {
                                        GroupBox {
                                            HStack {
                                                Text(dependency.name)
                                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                                Spacer()
                                                Text(dependency.version)
                                                    .font(.system(size: 12, design: .rounded))
                                                    .foregroundStyle(.secondary)
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
                                    
                                    if dependencies.last != dependency {
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(Color(.xOutline))
                                    }
                                }
                            }
                            .backgroundStyle(Color(.xCardBackground))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .title) {
                    Text("ABOUT")
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .tracking(2)
                }
            }
            .sheet(item: $selected) { dependency in
                SafariView(url: dependency.url)
            }
        }
    }
}

extension UIUserInterfaceIdiom {
    func toString() -> String {
        switch (self) {
        case .unspecified:
            return "Unspecified"
        case .phone:
            return "Phone"
        case .pad:
            return "Pad"
        case .tv:
            return "TV"
        case .carPlay:
            return "CarPlay"
        case .mac:
            return "Mac"
        case .vision:
            return "Vision"
        default:
            return "Unknown"
        }
    }
}
