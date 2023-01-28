//
//  File.swift
//  
//
//  Created by Jae Seung Lee on 1/28/23.
//

import Foundation
import os

public class SubwayFeedDownloader {
    private let httpHeaderForApiKey = "x-api-key"
    private let apiKey: String
    private let mtaFeedDownloader = MTAFeedDownloader.shared
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func download(from subwayFeedURL: SubwayFeedURL, completionHandler: @escaping (MTAFeedWrapper?, MTAFeedDownloadError?) -> Void) -> Void {
        guard let url = subwayFeedURL.url() else {
            completionHandler(nil, MTAFeedDownloadError.noURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apiKey, forHTTPHeaderField: httpHeaderForApiKey)
        
        mtaFeedDownloader.download(with: urlRequest) { wrapper, error in
            completionHandler(wrapper, error)
        }
    }
}
