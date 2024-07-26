//
//  GitHubService.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

enum GitHubService: ServiceProtocol {
    case list(page: Int)
    case search(phrase: String, page: Int)
    case details(username: String)

    var baseUrl: URL {
        URL(string: Endpoint.baseUrl)!
    }

    var path: String {
        switch self {
        case .list:
            return "users"
        case .search:
            return "search/users"
        case .details(let username):
            return "users/\(username)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .search, .details:
            return .get
        }
    }

    var headers: Headers? {
        switch self {
        case .list(let page):
            return ["slice": "\(page)"]
        case .search(let phrase, let page):
            return ["q": phrase,
                    "page": "\(page)"]
        case .details:
            return nil
        }
    }
}
