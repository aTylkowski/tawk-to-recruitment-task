//
//  UserDetails.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import Foundation

struct UserProfile: Decodable {
    let login: String
    let avatarURL: String
    let url: String
    let htmlURL: String
    let type: String
    let siteAdmin: Bool
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let followers: Int
    let following: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case login, name, company, blog, location, email, hireable, bio, type, followers, following
        case siteAdmin = "site_admin"
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension UserProfile {
    static let empty = UserProfile(login: "",
                                   avatarURL: "",
                                   url: "",
                                   htmlURL: "",
                                   type: "",
                                   siteAdmin: false,
                                   name: nil,
                                   company: nil,
                                   blog: nil,
                                   location: nil,
                                   email: nil,
                                   hireable: nil,
                                   bio: nil,
                                   followers: 0,
                                   following: 0,
                                   createdAt: "",
                                   updatedAt: "")
}
