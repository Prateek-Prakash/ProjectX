//
//  DateExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 1/17/26.
//

import Foundation

extension Date {
    func asFractionalDateTime() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]
        return formatter.string(from: self)
    }
    
    func nextOccurrence(ofHour hour: Int, in identifier: String = "America/New_York") -> Date? {
        var calendar = Calendar.current
        
        guard let zone = TimeZone(identifier: identifier) else { return nil }
        calendar.timeZone = zone
        
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        
        components.hour = hour
        components.minute = 0
        components.second = 0
        
        guard var target = calendar.date(from: components) else { return nil }
        
        if self > target {
            target = calendar.date(byAdding: .day, value: 1, to: target) ?? target
        }
        
        return target
    }
}
