//
//  File.swift
//  
//
//  Created by Jae Seung Lee on 1/23/23.
//

import Foundation
import os

class MTAFeedProcessor {
    private static let logger = Logger()
    
    public static let shared = MTAFeedProcessor()
    
    func process(_ feedMessage: TransitRealtime_FeedMessage) -> MTAFeedWrapper {
        var mtaFeedWrapper = MTAFeedWrapper()
        
        let date = getFeedDate(from: feedMessage)
        MTAFeedProcessor.logger.debug("feedDate=\(date.formatted())")
        
        var vehicles = [MTAVehicle]()
        var tripUpdates = [MTATripUpdate]()
        feedMessage.entity.forEach { entity in
            let _ = getAlert(from: entity, at: date)
            
            if let mtaVehicle = getVehicle(from: entity) {
                if let routeId = mtaVehicle.trip?.routeId, "Q38" == routeId {
                    MTAFeedProcessor.logger.log("mtaVehicle = \(String(describing: mtaVehicle), privacy: .public)")
                }
                vehicles.append(mtaVehicle)
            }
            
            if let tripUpdate = getTripUpdate(from: entity) {
                if let routeId = tripUpdate.trip?.routeId, "Q38" == routeId {
                    MTAFeedProcessor.logger.log("tripUpdate = \(String(describing: tripUpdate), privacy: .public)")
                }
                tripUpdates.append(tripUpdate)
            }
            
        }
        
        // MTAFeedDownloader.logger.info("vehicles.count = \(String(describing: vehicles.count), privacy: .public)")
        
        var vehiclesByStopId = [String: [MTAVehicle]]()
        if !vehicles.isEmpty {
            for vehicle in vehicles {
                //ViewModel.logger.info("vehicle = \(String(describing: vehicle), privacy: .public)")
                if let stopId = vehicle.stopId {
                    if vehiclesByStopId.keys.contains(stopId) {
                        vehiclesByStopId[stopId]?.append(vehicle)
                    } else {
                        vehiclesByStopId[stopId] = [vehicle]
                    }
                }
            }
        }
        mtaFeedWrapper.vehiclesByStopId = vehiclesByStopId
        
        var tripUpdatesByTripId = [String: [MTATripUpdate]]()
        if !tripUpdates.isEmpty {
            for tripUpdate in tripUpdates {
                if let tripId = tripUpdate.trip?.tripId {
                    if tripUpdatesByTripId.keys.contains(tripId) {
                        tripUpdatesByTripId[tripId]?.append(tripUpdate)
                    } else {
                        tripUpdatesByTripId[tripId] = [tripUpdate]
                    }
                }
            }
        }
        mtaFeedWrapper.tripUpdatesByTripId = tripUpdatesByTripId
        return mtaFeedWrapper
    }
    
    private func getFeedDate(from feedMessage: TransitRealtime_FeedMessage) -> Date {
        return feedMessage.hasHeader ? Date(timeIntervalSince1970: TimeInterval(feedMessage.header.timestamp)) : Date()
    }
    
    private func getTripReplacementPeriods(from feedMessage: TransitRealtime_FeedMessage) -> [MTATripReplacementPeriod] {
        var mtaTripReplacementPeriods = [MTATripReplacementPeriod]()
        
        if feedMessage.hasHeader {
            let header = feedMessage.header
            if header.hasNyctFeedHeader {
                let nyctFeedHeader = header.nyctFeedHeader
                MTAFeedProcessor.logger.log("\(String(describing: nyctFeedHeader), privacy: .public)")
                
                nyctFeedHeader.tripReplacementPeriod.forEach { period in
                    let routeId = period.hasRouteID ? period.routeID : nil
                    let replacementPeriod = period.hasReplacementPeriod ? period.replacementPeriod : nil
                    
                    let endTime = (replacementPeriod?.hasEnd ?? false) ? Date(timeIntervalSince1970: TimeInterval(replacementPeriod!.end)) : nil
                    
                    let mtaTripReplacementPeriod = MTATripReplacementPeriod(routeId: routeId, endTime: endTime)
                    
                    mtaTripReplacementPeriods.append(mtaTripReplacementPeriod)
                }
                
            }
            MTAFeedProcessor.logger.log("\(String(describing: mtaTripReplacementPeriods), privacy: .public)")
        }
        
        return mtaTripReplacementPeriods
    }
    
    private func getAlert(from entity: TransitRealtime_FeedEntity, at date: Date) -> MTAAlert? {
        var mtaAlert: MTAAlert?
        if entity.hasAlert {
            let headerText = entity.alert.headerText.translation.first?.text ?? "No Header Text"
            mtaAlert = MTAAlert(delayedTrips: process(alert: entity.alert), headerText: headerText, date: date)
            MTAFeedProcessor.logger.debug("mtaAlert=\(String(describing: mtaAlert), privacy: .public)")
        }
        return mtaAlert
    }
    
    private func getVehicle(from entity: TransitRealtime_FeedEntity) -> MTAVehicle? {
        var mtaVehicle: MTAVehicle?
        if entity.hasVehicle {
            let vehicle = entity.vehicle
            //let measured = Date(timeIntervalSince1970: TimeInterval(vehicle.timestamp))
            //MTAFeedDownloader.logger.info("vehicle = \(String(describing: vehicle), privacy: .public)")
            //MTAFeedDownloader.logger.info("date = \(dateFormatter.string(from: measured))")
            
            // https://developers.google.com/transit/gtfs-realtime/reference#message-vehicleposition
            let status = vehicle.hasCurrentStatus ? MTAVehicleStatus(from: vehicle.currentStatus) : .inTransitTo
            let stopSequence = vehicle.hasCurrentStopSequence ? UInt(vehicle.currentStopSequence) : nil
            let stopId = vehicle.hasStopID ? vehicle.stopID : nil
            let trip = vehicle.hasTrip ? getMTATrip(from: vehicle.trip) : nil
            let date = vehicle.hasTimestamp ? Date(timeIntervalSince1970: TimeInterval(vehicle.timestamp)) : Date()
            
            mtaVehicle = MTAVehicle(status: status,
                                    stopId: stopId,
                                    stopSequence: stopSequence,
                                    timestamp: date,
                                    trip: trip)
        }
        //MTAFeedDownloader.logger.info("mtaVehicle = \(String(describing: mtaVehicle), privacy: .public)")
        return mtaVehicle
    }
    
    private func getTripUpdate(from entity: TransitRealtime_FeedEntity) -> MTATripUpdate? {
        var mtaTripUpdate: MTATripUpdate?
        if entity.hasTripUpdate {
            let tripUpdate = entity.tripUpdate
            //MTAFeedDownloader.logger.info("tripUpdate = \(String(describing: tripUpdate), privacy: .public)")
            
            let trip = tripUpdate.hasTrip ? getMTATrip(from: tripUpdate.trip) : nil
            
            var mtaStopTimeUpdates = [MTAStopTimeUpdate]()
            
            tripUpdate.stopTimeUpdate.forEach { update in
                
                let stopId = update.hasStopID ? update.stopID : nil
                let arrivalTime = update.hasArrival ? Date(timeIntervalSince1970: TimeInterval(update.arrival.time)) : nil
                let departureTime = update.hasDeparture ? Date(timeIntervalSince1970: TimeInterval(update.departure.time)) : nil
                
                let nyctStopTimeUpdate = update.hasNyctStopTimeUpdate ? update.nyctStopTimeUpdate : nil
                
                let scheduledTrack = (nyctStopTimeUpdate?.hasScheduledTrack ?? false) ? nyctStopTimeUpdate?.scheduledTrack : nil
                let actualTrack = (nyctStopTimeUpdate?.hasActualTrack ?? false) ? nyctStopTimeUpdate?.actualTrack : nil
                
                let mtaStopTimeUpdate = MTAStopTimeUpdate(stopId: stopId,
                                                          arrivalTime: arrivalTime,
                                                          departureTime: departureTime,
                                                          scheduledTrack: scheduledTrack,
                                                          actualTrack: actualTrack)
                
                mtaStopTimeUpdates.append(mtaStopTimeUpdate)
                
            }
            
            mtaTripUpdate = MTATripUpdate(trip: trip, stopTimeUpdates: mtaStopTimeUpdates)
        }
        //MTAFeedDownloader.logger.info("mtaTripUpdate = \(String(describing: mtaTripUpdate), privacy: .public)")
        return mtaTripUpdate
    }
    
    private func process(alert: TransitRealtime_Alert) -> [MTATrip] {
        var trips = [MTATrip]()
        alert.informedEntity.forEach { entity in
            if entity.hasTrip {
                let trip = entity.trip
                
                if trip.hasNyctTripDescriptor {
                    let nyctTrip = trip.nyctTripDescriptor
                    
                    let mtaTrip = MTATrip(tripId: trip.tripID,
                                          routeId: trip.routeID,
                                          trainId: nyctTrip.trainID,
                                          direction: MTADirection(from: nyctTrip.direction))
                    
                    trips.append(mtaTrip)
                }
            }
        }
        return trips
    }
    
    private func getMTATrip(from trip: TransitRealtime_TripDescriptor) -> MTATrip {
        let nyctTrip = trip.nyctTripDescriptor
        
        let tripId = trip.hasTripID ? trip.tripID : nil
        let routeId = trip.hasRouteID ? trip.routeID : nil
        let trainId = nyctTrip.hasTrainID ? nyctTrip.trainID : nil
        let direction = nyctTrip.hasDirection ? MTADirection(from: nyctTrip.direction) : nil
        let assigned = nyctTrip.hasIsAssigned ? nyctTrip.isAssigned : nil
        
        let startDate = trip.hasStartDate ? trip.startDate : nil
        let startTime = trip.hasStartTime ? trip.startTime : nil
        
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US")
        //dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMdd HH:mm:ss")
        dateFormatter.dateFormat = "yyyyMMdd HH:mm:ss"
        
        var start: Date?
        if startDate != nil && startTime != nil {
            start = dateFormatter.date(from: "\(startDate!) \(startTime!)")
            // ViewModel.logger.info("start = \(String(describing: start), privacy: .public) from \(startDate!) \(startTime!)")
        } else if startDate != nil {
            // TODO: start time from tripId?
            
        }
        
        return MTATrip(tripId: tripId,
                       routeId: routeId,
                       start: start,
                       assigned: assigned,
                       trainId: trainId,
                       direction: direction)
    }
}
