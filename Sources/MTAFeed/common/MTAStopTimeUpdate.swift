//
//  MTAStopTimeUpdate.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTAStopTimeUpdate: Identifiable {
    public var id: String {
        return stopId ?? UUID().uuidString
    }
    
    public let stopId: String?
    public let arrivalTime: Date?
    public let departureTime: Date?
    public let scheduledTrack: String?
    public let actualTrack: String?
    
    public var eventTime: Date? {
        return arrivalTime ?? departureTime
    }
    
    public init(stopId: String?, arrivalTime: Date?, departureTime: Date?, scheduledTrack: String?, actualTrack: String?) {
        self.stopId = stopId
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
        self.scheduledTrack = scheduledTrack
        self.actualTrack = actualTrack
    }
}
