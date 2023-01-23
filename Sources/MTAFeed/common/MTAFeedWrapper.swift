//
//  MTAFeedWrapper.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTAFeedWrapper {
    public var vehiclesByStopId = [String: [MTAVehicle]]()
    public var tripUpdatesByTripId = [String: [MTATripUpdate]]()
}
