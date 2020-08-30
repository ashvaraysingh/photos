//
//  APIClient.swift
//  Photos
//
//  Created by Ashvarya Singh on 29/08/20.
//  Copyright © 2020 Ashvaray. All rights reserved.
//

import Foundation

typealias result<T> = (Result<[T], Error>) -> Void

enum DataError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case serverError
}

class APIClient {
    // MARK: - Private Properties
    private let session: URLSessionProtocol
    private var task: URLSessionDataTaskProtocol?
    
    // MARK: - Initialiser
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    static let shared = { APIClient(session: URLSession.shared) }()
    
    // MARK: - Data Task Helper
    func dataTask<T: Decodable>(of type: T.Type, from request: RequestProtocol, completion: @escaping result<T>) {
        var urlRequest = URLRequest(url: request.baseURL.appendingPathComponent(request.path),
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: Constants.Service.timeout)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.httpBody = request.httpBody
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            if 200 ... 299 ~= response.statusCode {
                if let data = data {
                    do {
                        let decodedData: [T] = try JSONDecoder().decode([T].self, from: data)
                        completion(.success(decodedData))
                    }
                    catch {
                        completion(.failure(DataError.decodingError))
                    }
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
