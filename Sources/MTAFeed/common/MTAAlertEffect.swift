//
//  MTAAlertEffect.swift
//
//
//  Created by Jae Seung Lee on 11/4/26.
//

import Foundation

/// GTFS-Realtime `Alert.effect`. MTA Bus Time marks trip cancellations with `reducedService`.
public enum MTAAlertEffect: String, Codable, Sendable {
    case noService
    case reducedService
    case significantDelays
    case detour
    case additionalService
    case modifiedService
    case otherEffect
    case unknownEffect
    case stopMoved

    init(from effect: TransitRealtime_Alert.Effect) {
        switch effect {
        case .noService:
            self = .noService
        case .reducedService:
            self = .reducedService
        case .significantDelays:
            self = .significantDelays
        case .detour:
            self = .detour
        case .additionalService:
            self = .additionalService
        case .modifiedService:
            self = .modifiedService
        case .otherEffect:
            self = .otherEffect
        case .unknownEffect:
            self = .unknownEffect
        case .stopMoved:
            self = .stopMoved
        }
    }
}

/// GTFS-Realtime `Alert.cause`.
public enum MTAAlertCause: String, Codable, Sendable {
    case unknownCause
    case otherCause
    case technicalProblem
    case strike
    case demonstration
    case accident
    case holiday
    case weather
    case maintenance
    case construction
    case policeActivity
    case medicalEmergency

    init(from cause: TransitRealtime_Alert.Cause) {
        switch cause {
        case .unknownCause:
            self = .unknownCause
        case .otherCause:
            self = .otherCause
        case .technicalProblem:
            self = .technicalProblem
        case .strike:
            self = .strike
        case .demonstration:
            self = .demonstration
        case .accident:
            self = .accident
        case .holiday:
            self = .holiday
        case .weather:
            self = .weather
        case .maintenance:
            self = .maintenance
        case .construction:
            self = .construction
        case .policeActivity:
            self = .policeActivity
        case .medicalEmergency:
            self = .medicalEmergency
        }
    }
}
