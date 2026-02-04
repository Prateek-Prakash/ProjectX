//
//  DoubleExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/20/25.
//

import Foundation

extension Double {
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: self)) ?? "--"
    }
    
    func asPoints(_ digits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = digits
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(value: self)) ?? "--"
    }
    
    var decimalCount: Int {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return 0
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 20
        formatter.groupingSeparator = ""
        
        guard let stringValue = formatter.string(from: NSNumber(value: self)) else {
            return 0
        }
        
        if let decimalPart = stringValue.split(separator: ".").last {
            return decimalPart.count
        }
        
        return 0
    }
}
