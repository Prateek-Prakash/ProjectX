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
}
