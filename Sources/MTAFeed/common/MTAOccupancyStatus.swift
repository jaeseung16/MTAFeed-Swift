//
//  MTAOccupancyStatus.swift
//
//
//  Created by Jae Seung Lee on 11/4/26.
//

import Foundation

/// GTFS-Realtime `VehiclePosition.occupancy_status`.
public enum MTAOccupancyStatus: String, Codable, Sendable {
    case empty
    case manySeatsAvailable
    case fewSeatsAvailable
    case standingRoomOnly
    case crushedStandingRoomOnly
    case full
    case notAcceptingPassengers

    init(from status: TransitRealtime_VehiclePosition.OccupancyStatus) {
        switch status {
        case .empty:
            self = .empty
        case .manySeatsAvailable:
            self = .manySeatsAvailable
        case .fewSeatsAvailable:
            self = .fewSeatsAvailable
        case .standingRoomOnly:
            self = .standingRoomOnly
        case .crushedStandingRoomOnly:
            self = .crushedStandingRoomOnly
        case .full:
            self = .full
        case .notAcceptingPassengers:
            self = .notAcceptingPassengers
        }
    }
}
