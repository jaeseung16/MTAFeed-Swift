//
//  File.swift
//  
//
//  Created by Jae Seung Lee on 1/28/23.
//

import Foundation
import os

public class SubwayFeedDownloader {
    private let apiKey: String
    private let mtaFeedDownloader = MTAFeedDownloader<SubwayFeedURL>()
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}
