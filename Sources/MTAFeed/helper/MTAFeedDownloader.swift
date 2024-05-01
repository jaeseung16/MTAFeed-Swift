//
//  MTAFeedDownloader.swift
//  NYCBusNearby
//
//  Created by Jae Seung Lee on 1/13/23.
//

import Foundation
import os

public class MTAFeedDownloader<K> where K: MTAFeedURL {
    private let logger = Logger()
    
    private let mtaFeedProcessor = MTAFeedProcessor.shared
    
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func download(from mtaFeedURL: K, completionHandler: @escaping (MTAFeedWrapper?, MTAFeedDownloadError?) -> Void) -> Void {
        guard let urlRequest = mtaFeedURL.urlRequest(apiKey: apiKey) else {
            completionHandler(nil, MTAFeedDownloadError.noURL)
            return
        }
        
        download(with: urlRequest) { wrapper, error in
            completionHandler(wrapper, error)
        }
    }
    
    public func download(from mtaFeedURL: K) async throws -> MTAFeedWrapper? {
        var mtaFeedWrapper: MTAFeedWrapper?
        if let urlRequest = mtaFeedURL.urlRequest(apiKey: apiKey) {
            mtaFeedWrapper = try await download(with: urlRequest)
        }
        return mtaFeedWrapper
    }
    
    public func download(with urlRequest: URLRequest, completionHandler: @escaping (MTAFeedWrapper?, MTAFeedDownloadError?) -> Void) -> Void {
        download(with: urlRequest) { result in
            switch result {
            case .success(let feed):
                let mtaFeedWrapper = self.mtaFeedProcessor.process(feed)
                completionHandler(mtaFeedWrapper, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    public func download(with urlRequest: URLRequest) async throws -> MTAFeedWrapper {
        let feed: TransitRealtime_FeedMessage = try await download(with: urlRequest)
        return mtaFeedProcessor.process(feed)
    }
    
    private func download(with urlRequest: URLRequest, completionHandler: @escaping (Result<TransitRealtime_FeedMessage, MTAFeedDownloadError>) -> Void) -> Void {
        self.logger.info("Start downloading feeds: urlRequest=\(urlRequest, privacy: .public)")
        let start = Date()
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else {
                self.logger.error("No data downloaded: urlRequest=\(urlRequest, privacy: .public)")
                completionHandler(.failure(.noData))
                return
            }
            
            self.logger.debug("data = \(String(describing: data))")
            
            let feed = try? TransitRealtime_FeedMessage(serializedData: data, extensions: Nyct_u45Subway_Extensions)
            guard let feed = feed else {
                self.logger.error("Cannot parse feed data: urlRequest=\(urlRequest, privacy: .public)")
                completionHandler(.failure(.cannotParse))
                return
            }
            
            completionHandler(.success(feed))
            self.logger.log("It took \(DateInterval(start: start, end: Date()).duration) sec to download feed: urlRequest=\(urlRequest, privacy: .public)")
        }
        
        task.resume()
    }
    
    private func download(with urlRequest: URLRequest) async throws -> TransitRealtime_FeedMessage {
        logger.info("Start downloading feeds: urlRequest=\(urlRequest, privacy: .public)")
        
        let start = Date()
        
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpURLResponse = urlResponse as? HTTPURLResponse, httpURLResponse.statusCode == 200 else {
            throw MTAFeedDownloadError.noData
        }
        
        self.logger.debug("data = \(String(describing: data))")
        
        let feed = try? TransitRealtime_FeedMessage(serializedData: data, extensions: Nyct_u45Subway_Extensions)
        
        guard let feed = feed else {
            logger.error("Cannot parse feed data: urlRequest=\(urlRequest, privacy: .public)")
            throw MTAFeedDownloadError.cannotParse
        }
        
        logger.log("It took \(DateInterval(start: start, end: Date()).duration) sec to download feed: urlRequest=\(urlRequest, privacy: .public)")
        
        return feed
    }

}
