//
//  MTATripReplacementPeriod.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTATripReplacementPeriod {
    public let routeId: String?
    public let endTime: Date?
    
    public init(routeId: String?, endTime: Date?) {
        self.routeId = routeId
        self.endTime = endTime
    }
}
