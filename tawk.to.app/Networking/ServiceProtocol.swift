//
//  SceneDelegate.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

public typealias Headers = [String: String]

public protocol ServiceProtocol {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: Headers? { get }
}
