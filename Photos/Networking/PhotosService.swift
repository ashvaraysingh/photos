//
//  PhotosService.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation

enum PhotosAPI {
    case getPhotosList
    case getPhoto(id: String)
}

extension PhotosAPI: RequestProtocol {
    var baseURL: URL {
        guard let url = URL(string: Constants.Service.baseURL) else {
            fatalError("BaseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getPhotosList:
            return "v2/list"
        case .getPhoto(let id):
            return "id/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getPhotosList:
            return .get
        case .getPhoto:
            return .get
        }
    }
    
    var httpBody: Data? {
        switch self {
        case .getPhotosList:
            return nil
        default:
            return nil
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
