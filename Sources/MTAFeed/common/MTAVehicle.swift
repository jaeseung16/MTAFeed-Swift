//
//  MTAVehicle.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTAVehicle: Hashable {
    public let status: MTAVehicleStatus
    public let stopId: String?
    public let stopSequence: UInt?
    public let timestamp: Date?
    public let trip: MTATrip?
    
    public init(status: MTAVehicleStatus, stopId: String?, stopSequence: UInt?, timestamp: Date?, trip: MTATrip?) {
        self.status = status
        self.stopId = stopId
        self.stopSequence = stopSequence
        self.timestamp = timestamp
        self.trip = trip
    }
}
