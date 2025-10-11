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
    case holaPrime = "Hola Prime"
    case lucidTrading = "Lucid Trading"
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
        case .holaPrime:
            return 200
        case .lucidTrading:
            return 100
        case .topstep:
            return 150
        case .tradeify:
            return 150
        }
    }
}
