//
//  MTATrip.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public struct MTATrip: CustomStringConvertible, Hashable {
    public var tripId: String?
    public var routeId: String?
    public var start: Date?
    public var assigned: Bool?
    public var trainId: String?
    public var direction: MTADirection?
    
    public var description: String {
        return "MTATrip[tripId=\(String(describing: tripId)), routeId=\(String(describing: routeId)), start=\(String(describing: start)), assigned=\(String(describing: assigned)) trainId=\(String(describing: trainId)), direction=\(String(describing: direction))]"
    }
    
    public func getDirection() -> MTADirection? {
        if let direction = direction {
            return direction
        } else if let tripId = tripId {
            let routeAndDirection = String(tripId.split(separator: "_")[1])
            let direction = routeAndDirection.split(separator: ".").last ?? ""
            return MTADirection(rawValue: String(direction))
        } else {
            return nil
        }
    }
    
    /*
    func getRouteId() -> MTARouteId? {
        if let tripId = tripId {
            let routeAndDirection = String(tripId.split(separator: "_")[1])
            let route = routeAndDirection.split(separator: ".")[0]
            return MTARouteId(rawValue: String(route))
        } else {
            return nil
        }
    }
    */
    
    public func getOriginTime() -> Date {
        if let tripId = tripId, let timecode = Double(tripId.split(separator: "_")[0]) {
            let startOfDay = Calendar.current.startOfDay(for: Date())
            return Date(timeInterval: timecode / 100.0 * 60.0, since: startOfDay)
        } else {
            return Date()
        }
    }
}
