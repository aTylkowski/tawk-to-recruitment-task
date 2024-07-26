//
//  PlaceholderType.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import Foundation

enum PlaceholderType {
    case empty
    case noData
    case initial

    var title: String {
        switch self {
        case .empty:
            return ""
        case .noData:
            return "No results found"
        case .initial:
            return "Type in searchbar to display users"
        }
    }
}
