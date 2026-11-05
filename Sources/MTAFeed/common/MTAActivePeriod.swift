//
//  MTAActivePeriod.swift
//
//
//  Created by Jae Seung Lee on 11/4/26.
//

import Foundation

/// GTFS-Realtime `TimeRange`. A missing `start` or `end` means the period is open on that side.
public struct MTAActivePeriod: Hashable, Sendable {
    public let start: Date?
    public let end: Date?

    public init(start: Date? = nil, end: Date? = nil) {
        self.start = start
        self.end = end
    }

    public func contains(_ date: Date) -> Bool {
        if let start, date < start {
            return false
        }
        if let end, date > end {
            return false
        }
        return true
    }
}
