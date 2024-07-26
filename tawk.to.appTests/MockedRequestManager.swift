//
//  MockedRequestManager.swift
//  tawk.to.appTests
//
//  Created by Aleksy Tylkowski on 26/07/2024.
//

import Foundation

final class MockRequestManager: RequestManager {
    var mockData: Data?
    var mockError: Error?
    
    override func get<T: Decodable>(for type: T.Type = T.self, service: ServiceProtocol, reloadIgnoringLocalCacheData: Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let data = mockData {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
    }
}
