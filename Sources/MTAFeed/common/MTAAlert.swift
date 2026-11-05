//
//  MTAAlert.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTAAlert: Sendable {
    /// Subway trips (with an NYCT trip descriptor) named by the alert. Bus alerts leave this empty; use `informedEntities`.
    public let delayedTrips: [MTATrip]
    public let headerText: String
    /// Feed header timestamp.
    public let date: Date
    /// `FeedEntity.id`.
    public let id: String?
    public let descriptionText: String?
    public let effect: MTAAlertEffect?
    public let cause: MTAAlertCause?
    public let informedEntities: [MTAInformedEntity]
    public let activePeriods: [MTAActivePeriod]
    
    public init(delayedTrips: [MTATrip], headerText: String, date: Date, id: String? = nil, descriptionText: String? = nil, effect: MTAAlertEffect? = nil, cause: MTAAlertCause? = nil, informedEntities: [MTAInformedEntity] = [], activePeriods: [MTAActivePeriod] = []) {
        self.delayedTrips = delayedTrips
        self.headerText = headerText
        self.date = date
        self.id = id
        self.descriptionText = descriptionText
        self.effect = effect
        self.cause = cause
        self.informedEntities = informedEntities
        self.activePeriods = activePeriods
    }
    
    /// Route IDs named directly or through a trip in `informedEntities`.
    public var routeIds: Set<String> {
        return Set(informedEntities.compactMap { $0.routeId ?? $0.trip?.routeId })
    }
    
    /// Trip IDs named in `informedEntities`.
    public var tripIds: Set<String> {
        return Set(informedEntities.compactMap { $0.trip?.tripId })
    }
    
    /// True when there are no active periods (always active) or one of them contains `date`.
    public func isActive(at date: Date = Date()) -> Bool {
        return activePeriods.isEmpty || activePeriods.contains { $0.contains(date) }
    }
}
