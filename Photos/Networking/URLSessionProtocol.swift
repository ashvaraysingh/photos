//
//  URLSessionProtocol.swift
//  Photos
//
//  Created by Ashvarya Singh on 30/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}


protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}
