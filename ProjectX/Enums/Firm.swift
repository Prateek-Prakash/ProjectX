//
//  Firm.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/23/25.
//

import Foundation
import SwiftUI

enum Firm: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case alphaFutures = "Alpha Futures"
    case aquaFutures = "Aqua Futures"
    case fundingFutures = "Funding Futures"
    case lucidTrading = "Lucid Trading"
    case theFuturesDesk = "The Futures Desk"
    case topstep = "Topstep"
    case tradeify = "Tradeify"
    
    var displayName: String {
        return self.rawValue.replacingOccurrences(of: " ", with: "") + "X"
    }
    
    var headerName: String {
        return self.rawValue.uppercased()
    }
    
    var winningDay: Double {
        switch self {
        case .alphaFutures:
            return 200
        case .aquaFutures:
            return 100
        case .fundingFutures:
            return 100
        case .lucidTrading:
            return 100
        case .theFuturesDesk:
            return 0
        case .topstep:
            return 150
        case .tradeify:
            return 150
        }
    }
    
    var automationType: AutomationType {
        switch self {
        case .alphaFutures:
            return .semi
        case .aquaFutures:
            return .semi
        case .fundingFutures:
            return .semi
        case .lucidTrading:
            return .full
        case .theFuturesDesk:
            return .full
        case .topstep:
            return .full
        case .tradeify:
            return .full
        }
    }
}
