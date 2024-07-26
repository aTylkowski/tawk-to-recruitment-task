//
//  UserInfo.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation

struct UserInfo: Decodable {
    let id: Int
    let username: String
    let score: Double?
    let profileImageUrl: String
    let organizationsUrl: String
    var bio: String?
    var isInverted: Bool? = nil
    var isSeen: Bool? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case username = "login"
        case score
        case profileImageUrl = "avatar_url"
        case organizationsUrl = "organizations_url"
    }
}
