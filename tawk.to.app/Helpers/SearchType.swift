//
//  SearchType.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 25/07/2024.
//

import Foundation

enum SearchType {
    case remote
    case local

    var title: String {
        switch self {
        case .remote:
            "REMOTE"
        case .local:
            "LOCAL"
        }
    }
}
