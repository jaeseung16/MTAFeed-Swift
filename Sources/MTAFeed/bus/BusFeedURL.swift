//
//  MTABusFeedURL.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public enum BusFeedURL: String, CaseIterable {
    private static let urlPrefix = "https://gtfsrt.prod.obanyc.com/"
    
    case tripUpdates = "tripUpdates"
    case vehiclePositions = "vehiclePositions"
    case alerts = "alerts"
    
    public func url(with apiKey: String) -> URL? {
        return URL(string: BusFeedURL.urlPrefix + rawValue + apiKey)
    }
}
