//
//  SceneDelegate.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

class RequestManager {
    // MARK: - Public Methods
    func get<T: Decodable>(for type: T.Type = T.self,
                           service: ServiceProtocol,
                           reloadIgnoringLocalCacheData: Bool = true,
                           completion: @escaping (Result<T, Error>) -> Void) {
        let request = makeRequest(service: service, reloadIgnoringLocalCacheData: reloadIgnoringLocalCacheData)

        executeDataTask(with: request, completion: completion)
    }

    func post<T: Decodable, E: Encodable>(for type: T.Type = T.self,
                                          body: E? = nil,
                                          service: ServiceProtocol,
                                          reloadIgnoringLocalCacheData: Bool = true,
                                          completion: @escaping (Result<T, Error>) -> Void) {
        do {
            var request = makeRequest(service: service, reloadIgnoringLocalCacheData: reloadIgnoringLocalCacheData)
            request.httpMethod = HTTPMethod.post.rawValue
            request.httpBody = try body?.encoded()
            
            executeDataTask(with: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func put<T: Decodable, E: Encodable>(for type: T.Type = T.self,
                                         body: E? = nil,
                                         service: ServiceProtocol,
                                         reloadIgnoringLocalCacheData: Bool = true,
                                         completion: @escaping (Result<T, Error>) -> Void) {
        do {
            var request = makeRequest(service: service, reloadIgnoringLocalCacheData: reloadIgnoringLocalCacheData)
            request.httpMethod = HTTPMethod.put.rawValue
            request.httpBody = try body?.encoded()
            
            executeDataTask(with: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    func delete<T: Decodable, E: Encodable>(for type: T.Type = T.self,
                                            body: E? = nil,
                                            service: ServiceProtocol,
                                            reloadIgnoringLocalCacheData: Bool = true,
                                            completion: @escaping (Result<T, Error>) -> Void) {
        do {
            var request = makeRequest(service: service, reloadIgnoringLocalCacheData: reloadIgnoringLocalCacheData)
            request.httpMethod = HTTPMethod.delete.rawValue
            request.httpBody = try body?.encoded()
            
            executeDataTask(with: request, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Private Methods
    private func makeRequest(service: ServiceProtocol, reloadIgnoringLocalCacheData: Bool) -> URLRequest {
        var components = URLComponents(url: service.baseUrl.appendingPathComponent(service.path), resolvingAgainstBaseURL: true)

        var queryItems: [URLQueryItem] = []
        for (key, value) in service.headers ?? [:] {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        components?.queryItems = queryItems

        guard let url = components?.url else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        if reloadIgnoringLocalCacheData {
            request.cachePolicy = .reloadIgnoringLocalCacheData
        }
        request.setValue("request-language", forHTTPHeaderField: "pl")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = service.method.rawValue
        
        return request
    }

    private func executeDataTask<T: Decodable>(with request: URLRequest,
                                               completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error {
                    print("❌ executeDataTask error: \(error)")
                } else {
                    print("❌ executeDataTask error: no data")
                }
                completion(.failure(error ?? NetworkError.noData))
                return
            }

            if data.isEmpty, T.self == EmptyResponse.self {
                completion(.success(EmptyResponse() as! T))
                return
            }

            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }
        task.resume()
    }
}

fileprivate extension Encodable {
    func encoded() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}
