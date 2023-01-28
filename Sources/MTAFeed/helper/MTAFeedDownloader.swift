//
//  MTAFeedDownloader.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation
import os

public class MTAFeedDownloader {
    private static let logger = Logger()
    
    public static func download(with urlRequest: URLRequest, completionHandler: @escaping (MTAFeedWrapper?, MTAFeedDownloadError?) -> Void) -> Void {
        download(with: urlRequest) { result in
            switch result {
            case .success(let feed):
                let mtaFeedWrapper = MTAFeedProcessor.process(feed)
                completionHandler(mtaFeedWrapper, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    private static func download(with urlRequest: URLRequest, completionHandler: @escaping (Result<TransitRealtime_FeedMessage, MTAFeedDownloadError>) -> Void) -> Void {
        logger.info("Downloading feeds from url = \(getURLString(from: urlRequest), privacy: .public)")
        let start = Date()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                logger.error("No data downloaded from url = \(getURLString(from: urlRequest), privacy: .public)")
                completionHandler(.failure(.noData))
                return
            }
            
            MTAFeedDownloader.logger.debug("data = \(String(describing: data))")
            
            let feed = try? TransitRealtime_FeedMessage(serializedData: data, extensions: Nyct_u45Subway_Extensions)
            guard let feed = feed else {
                logger.error("Cannot parse feed data from \(getURLString(from: urlRequest), privacy: .public)")
                completionHandler(.failure(.cannotParse))
                return
            }
            
            completionHandler(.success(feed))
            logger.log("For url=\(getURLString(from: urlRequest)), it took \(DateInterval(start: start, end: Date()).duration) sec to download feed")
        }
        
        task.resume()
    }
    
    private static func getURLString(from urlRequest: URLRequest) -> String {
        return urlRequest.url?.absoluteString ?? "No Given URL"
    }

}
