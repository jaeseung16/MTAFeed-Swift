//
//  MTAScheduleRelationship.swift
//
//
//  Created by Jae Seung Lee on 11/4/26.
//

import Foundation

/// GTFS-Realtime `TripDescriptor.schedule_relationship`.
public enum MTAScheduleRelationship: String, Codable, Sendable {
    case scheduled
    case added
    case unscheduled
    case canceled

    init(from relationship: TransitRealtime_TripDescriptor.ScheduleRelationship) {
        switch relationship {
        case .scheduled:
            self = .scheduled
        case .added:
            self = .added
        case .unscheduled:
            self = .unscheduled
        case .canceled:
            self = .canceled
        }
    }
}
