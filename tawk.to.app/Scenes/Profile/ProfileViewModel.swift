//
//  ProfileViewModel.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 24/07/2024.
//

import SwiftUI

final class ProfileViewModel: ObservableObject {
    private let requestManager = RequestManager()

    private let username: String

    @Published var userProfile: UserProfile = .empty
    @Published var shouldShowError: Bool = false
    @Published var errorText: String = ""

    init(username: String) {
        self.username = username
    }

    func fetchUserDetails() {
        requestManager.get(for: UserProfile.self, service: GitHubService.details(username: username)) { [weak self] result in
            switch result {
            case .success(let userProfile):
                DispatchQueue.main.async {
                    self?.userProfile = userProfile
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.shouldShowError = true
                    self?.errorText = error.localizedDescription
                }
            }
        }
    }
}
