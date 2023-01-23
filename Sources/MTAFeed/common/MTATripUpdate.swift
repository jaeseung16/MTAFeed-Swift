//
//  MTATripUpdate.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTATripUpdate {
    public let trip: MTATrip?
    public let stopTimeUpdates: [MTAStopTimeUpdate]
}
