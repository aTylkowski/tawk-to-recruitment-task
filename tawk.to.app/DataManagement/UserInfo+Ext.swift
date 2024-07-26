//
//  UserInfo+Ext.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 25/07/2024.
//

import Foundation

extension UserInfo {
    init(entity: UserInfoEntity) {
        self.id = Int(entity.id)
        self.username = entity.username ?? ""
        self.score = entity.score
        self.profileImageUrl = entity.profileImageUrl ?? ""
        self.organizationsUrl = entity.organizationsUrl ?? ""
        self.bio = entity.bio
        self.isInverted = entity.isInverted
    }
}
