//
//  HapticViewModel.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/24/26.
//

import Combine
import Foundation

@MainActor
class HapticViewModel: ObservableObject {
    static let shared = HapticViewModel()
    
    @Published var success: Bool = false
    @Published var error: Bool = false
    @Published var selection: Bool = false
    
    func successHaptic() {
        success.toggle()
    }
    
    func errorHaptic() {
        error.toggle()
    }
    
    func selectionHaptic() {
        selection.toggle()
    }
}
