//
//  MTAFeedDownloadError.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation

public enum MTAFeedDownloadError: Error {
    case noURL
    case noData
    case cannotParse
}
