//
//  MTAInformedEntity.swift
//
//
//  Created by Jae Seung Lee on 11/4/26.
//

import Foundation

/// GTFS-Realtime `EntitySelector`: an agency, route, stop, or trip that an alert applies to.
public struct MTAInformedEntity: Hashable, Sendable {
    public let agencyId: String?
    public let routeId: String?
    public let routeType: Int?
    public let stopId: String?
    public let trip: MTATrip?

    public init(agencyId: String? = nil, routeId: String? = nil, routeType: Int? = nil, stopId: String? = nil, trip: MTATrip? = nil) {
        self.agencyId = agencyId
        self.routeId = routeId
        self.routeType = routeType
        self.stopId = stopId
        self.trip = trip
    }
}
