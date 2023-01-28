//
//  File.swift
//  
//
//  Created by Jae Seung Lee on 1/23/23.
//

import Foundation
import os

public class BusFeedDownloader {
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func download(from mtaBusFeedURL: BusFeedURL, completionHandler: @escaping (MTAFeedWrapper?, MTAFeedDownloadError?) -> Void) -> Void {
        guard let url = mtaBusFeedURL.url(with: apiKey) else {
            completionHandler(nil, MTAFeedDownloadError.noURL)
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        MTAFeedDownloader.download(with: urlRequest) { wrapper, error in
            completionHandler(wrapper, error)
        }
    }
}
