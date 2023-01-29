//
//  File.swift
//  
//
//  Created by Jae Seung Lee on 1/29/23.
//

import Foundation

public protocol MTAFeedURL {
    func urlRequest(apiKey: String?) -> URLRequest?
}
