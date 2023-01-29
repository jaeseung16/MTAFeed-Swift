//
//  MTASubwayFeedURL.swift
//  Protobuf
//
//  Created by Jae Seung Lee on 10/3/22.
//

import Foundation

public enum SubwayFeedURL: String, CaseIterable {
    private static let urlPrefix = "https://api-endpoint.mta.info/Dataservice/mtagtfsfeeds/nyct%2Fgtfs"
    private static let httpHeaderForApiKey = "x-api-key"
    
    case blue = "-ace"
    case orange = "-bdfm"
    case lightGreen = "-g"
    case brown = "-jz"
    case yellow = "-nqrw"
    case gray = "-l"
    case redGreenPurple = ""
    case statenIsland = "-si"
    
    private func url() -> URL? {
        return URL(string: SubwayFeedURL.urlPrefix + rawValue)
    }
    
}

extension SubwayFeedURL: MTAFeedURL {
    public func urlRequest(apiKey: String?) -> URLRequest? {
        guard let apiKey = apiKey, let url = url() else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apiKey, forHTTPHeaderField: SubwayFeedURL.httpHeaderForApiKey)
        return urlRequest
    }
}
