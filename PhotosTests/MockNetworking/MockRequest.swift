//
//  MockRequest.swift
//  PhotosTests
//
//  Created by Ashvarya Singh on 30/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation
@testable import Photos

typealias Completion = (Data?, URLResponse?, Error?) -> Void

enum MockRequest {
    case photos
}

extension MockRequest {
    //Identify request based on endpoint
    static func identifyRequest(request: URLRequest) -> MockRequest? {
        if request.url?.path == "/v2/list" {
            return photos
        }
        return nil
    }
    
    func completionHandler(request: URLRequest, completion: Completion) {
        guard let method = request.httpMethod, let httpMethod = HTTPMethod(rawValue: method) else {
            fatalError("Unknown HTTPMethod Used.")
        }
        
        switch (self, httpMethod) {
        case (.photos, .get):
            getPhotos(request: request, statusCode: 200, completion: completion)
        default:
            fatalError("Request not handled yet.")
        }
        
        
    }
    // MARK: - Helper Functions
    private func getPhotos(request: URLRequest, statusCode: Int, completion: Completion) {
        let path = Bundle.init(for: MockSession.self).path(forResource: "picsum", ofType: "json")
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe) else {
            let error = NSError(domain: "No stub data foubt", code: 0, userInfo: nil)
            completion(nil, nil, error)
            return
        }
        
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        completion(data, response, nil)
    }
}
