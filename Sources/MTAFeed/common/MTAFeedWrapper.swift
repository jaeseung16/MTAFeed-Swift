//
//  MTAFeedWrapper.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTAFeedWrapper {
    public var alerts = [MTAAlert]()
    public var vehiclesByStopId = [String: [MTAVehicle]]()
    public var tripUpdatesByTripId = [String: [MTATripUpdate]]()
    
    public init(alerts: [MTAAlert] = [MTAAlert](), vehiclesByStopId: [String : [MTAVehicle]] = [String: [MTAVehicle]](), tripUpdatesByTripId: [String : [MTATripUpdate]] = [String: [MTATripUpdate]]()) {
        self.alerts = alerts
        self.vehiclesByStopId = vehiclesByStopId
        self.tripUpdatesByTripId = tripUpdatesByTripId
    }
}
