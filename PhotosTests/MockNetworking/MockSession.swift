//
//  MockSession.swift
//  PhotosTests
//
//  Created by Ashvarya Singh on 30/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation
@testable import Photos

class MockSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        if let mockRequest =  MockRequest.identifyRequest(request: request) {
            mockRequest.completionHandler(request: request, completion: completionHandler)
        }
        
        return MockDataTask()
    }
}
