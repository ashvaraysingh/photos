//
//  RequestProtocol.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

protocol RequestProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var httpBody: Data? { get }
    var headers: HTTPHeaders? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete  = "DELETE"
}
