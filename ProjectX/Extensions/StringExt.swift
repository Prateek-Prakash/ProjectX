//
//  StringExt.swift
//  ProjectX
//
//  Created by Prateek Prakash on 8/26/25.
//

import Foundation

extension String {
    func toDateTime() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds
        ]
        return formatter.date(from: self)!
    }
    
    func asDate() -> String {
        let date = self.toDateTime()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    
    func asTime() -> String {
        let date = self.toDateTime()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter.string(from: date)
    }
}
