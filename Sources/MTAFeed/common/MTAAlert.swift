//
//  MTAAlert.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTAAlert {
    public let delayedTrips: [MTATrip]
    public let headerText: String
    public let date: Date
    
    public init(delayedTrips: [MTATrip], headerText: String, date: Date) {
        self.delayedTrips = delayedTrips
        self.headerText = headerText
        self.date = date
    }
}
