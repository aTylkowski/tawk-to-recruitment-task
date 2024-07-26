//
//  SceneDelegate.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case invalidResponse
    case requestFailed

    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response received"
        case .requestFailed:
            return "Request failed"
        }
    }
}
