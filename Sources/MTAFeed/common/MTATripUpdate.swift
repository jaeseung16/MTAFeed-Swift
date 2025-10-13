//
//  MTATripUpdate.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTATripUpdate: Sendable {
    public let trip: MTATrip?
    public let stopTimeUpdates: [MTAStopTimeUpdate]
    
    public init(trip: MTATrip?, stopTimeUpdates: [MTAStopTimeUpdate]) {
        self.trip = trip
        self.stopTimeUpdates = stopTimeUpdates
    }
}
