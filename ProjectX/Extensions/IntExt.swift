//
//  IntExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 11/20/25.
//

import Foundation

extension Int {
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "--"
    }
}
