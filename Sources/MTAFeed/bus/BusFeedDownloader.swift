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
    private let mtaFeedDownloader = MTAFeedDownloader<BusFeedURL>()
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
}
