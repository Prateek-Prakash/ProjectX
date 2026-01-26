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
    case theFuturesDesk = "The Futures Desk"
    case topstep = "Topstep"
    
    var displayName: String {
        return self.rawValue.replacingOccurrences(of: " ", with: "") + "X"
    }
    
    var headerName: String {
        return self.rawValue.uppercased()
    }
}
