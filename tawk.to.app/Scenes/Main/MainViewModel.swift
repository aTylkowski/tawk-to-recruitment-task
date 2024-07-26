//
//  MainViewModel.swift
//  tawk.to.app
//
//  Created by Aleksy Tylkowski on 22/07/2024.
//

import Foundation
import Network
import CoreData

final class MainViewModel {
    private let requestManager: RequestManager
    private let coreDataManager: CoreDataManager

    private var networkMonitor: NWPathMonitor?
    private var isDataLoadingRequired = false

    private var searchTimer: Timer?

    var users: [UserInfo] = []
    var searchType: SearchType = .remote

    var currentPage = 1
    var isFetching: Bool = false

    var onDataUpdated: (() -> Void)?
    var onPlaceholderUpdated: ((String) -> Void)?
    var onNetworkAvailable: ((Bool) -> Void)?

    init(requestManager: RequestManager = RequestManager(), coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.requestManager = requestManager
        self.coreDataManager = coreDataManager
        setupNetworkMonitor()
    }

    // MARK: Public Methods

    func getUsersList(phrase: String) {
        isFetching = true

        switch searchType {
        case .remote:
            if !phrase.isEmpty {
                fetchSpecificUsers(phrase: phrase)
            } else {
                fetchEntryUsers()
            }
        case .local:
            fetchEntryUsers(phrase: phrase)
        }
    }

    func fetchEntryUsers(phrase: String = "") {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.requestManager.get(for: [UserInfo].self, service: GitHubService.list(page: self.currentPage)) { result in
                self.fetchRemoteEntryUsers(phrase: phrase)
            }
        }
    }

    func toggleSearchType(text: String) {
        switch searchType {
        case .remote:
            searchType = .local
        case .local:
            searchType = .remote
        }
        currentPage = 1
        getUsersList(phrase: text)
    }

    // MARK: Private Methods

    private func setupNetworkMonitor() {
        networkMonitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        networkMonitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    if self?.isDataLoadingRequired == true {
                        self?.onNetworkAvailable?(true)
                        self?.isDataLoadingRequired = false
                    }
                } else {
                    self?.isDataLoadingRequired = true
                    self?.onNetworkAvailable?(false)
                }
            }
        }
        networkMonitor?.start(queue: queue)
    }

    private func fetchRemoteEntryUsers(phrase: String) {
        requestManager.get(for: [UserInfo].self, service: GitHubService.list(page: self.currentPage)) { result in
            self.handleEntryUsersResult(result: result, phrase: phrase)
        }
    }

    private func handleEntryUsersResult(result: Result<[UserInfo], Error>, phrase: String) {
        switch result {
        case .success(let items):
            handleSuccessfulEntryUsers(items: items, phrase: phrase)
        case .failure(let failure):
            fetchLocalUsers(phrase: phrase, failure: failure)
        }
    }

    private func handleSuccessfulEntryUsers(items: [UserInfo], phrase: String) {
        var filteredUsers: [UserInfo]

        if phrase.isEmpty {
            filteredUsers = items
        } else {
            filteredUsers = items.filter { $0.username.lowercased().contains(phrase.lowercased()) }
        }

        // TODO: REGARDLESS OF THE CURRENT PAGE (SLICE), THE RESPONSE FROM API IS ALWAYS THE SAME. THAT IS WHY I'M ASSIGNING USERS EACH TIME HERE AND NOT APPENDING

//        if currentPage == 1 {
            users = filteredUsers
//        } else {
//            users.append(contentsOf: filteredUsers)
//        }
        assignIsInverted()
        saveUsersToCoreData(users: filteredUsers)

        currentPage += 1
        isFetching = false

        DispatchQueue.main.async {
            self.onDataUpdated?()
            self.onPlaceholderUpdated?(self.users.isEmpty ? PlaceholderType.noData.title : PlaceholderType.empty.title)
        }
    }

    private func fetchSpecificUsers(phrase: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
            guard let self = self, !phrase.isEmpty else {
                DispatchQueue.main.async {
                    self?.showPlaceholder(text: PlaceholderType.noData.title)
                }
                return
            }
            self.requestManager.get(for: SearchResult.self, service: GitHubService.search(phrase: phrase, page: self.currentPage)) { result in
                self.handleSpecificUsersResult(result: result)
            }
        }
    }

    private func handleSpecificUsersResult(result: Result<SearchResult, Error>) {
        switch result {
        case .success(let searchResult):
            handleSuccessfulSpecificUsers(searchResult: searchResult)
        case .failure(let failure):
            handleFailure(failure: failure)
        }
    }

    private func handleSuccessfulSpecificUsers(searchResult: SearchResult) {
        if currentPage == 1 {
            users = searchResult.items
        } else {
            users.append(contentsOf: searchResult.items)
        }
        assignIsInverted()
        // TODO: USERS ARE SAVED ONLY FOR GLOBAL SEARCH (ONE USING 'SLICE')
//        saveUsersToCoreData(users: searchResult.items)
        currentPage += 1
        isFetching = false

        DispatchQueue.main.async {
            self.onDataUpdated?()
            self.onPlaceholderUpdated?(self.users.isEmpty ? PlaceholderType.noData.title : PlaceholderType.empty.title)
        }
    }

    private func handleFailure(failure: Error) {
        isFetching = false
        DispatchQueue.main.async {
            self.showPlaceholder(text: "Error fetching users: \n\n\(failure.localizedDescription)")
        }
    }

    private func fetchLocalUsers(phrase: String, failure: Error) {
        let fetchRequest: NSFetchRequest<UserInfoEntity> = UserInfoEntity.fetchRequest()
        if !phrase.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "username CONTAINS[c] %@", phrase)
        }
        do {
            let userEntities = try coreDataManager.mainContext.fetch(fetchRequest)
            users = userEntities.map { UserInfo(entity: $0) }
            DispatchQueue.main.async {
                self.onDataUpdated?()
                self.onPlaceholderUpdated?(self.users.isEmpty ? "Error fetching users: \n\n\(failure.localizedDescription)" : PlaceholderType.empty.title)
            }
            isFetching = false
        } catch {
            handleFailure(failure: failure)
            print("Error fetching local users: \(error)")
        }
    }

    private func assignIsInverted() {
        for (index, _) in self.users.enumerated() {
            if (index + 1) % 4 == 0 {
                self.users[index].isInverted = true
            }
        }
    }

    private func showPlaceholder(text: String) {
        users = []
        onDataUpdated?()
        onPlaceholderUpdated?(text)
    }

    private func saveUsersToCoreData(users: [UserInfo]) {
        let context = coreDataManager.backgroundContext

        context.perform {
            users.forEach { user in
                let userEntity = UserInfoEntity(context: context)
                userEntity.username = user.username
                userEntity.score = user.score ?? 0
                userEntity.profileImageUrl = user.profileImageUrl
                userEntity.organizationsUrl = user.organizationsUrl
                userEntity.bio = user.bio
            }
            do {
                try context.save()
            } catch {
                print("Failed to save users to CoreData: \(error)")
            }
        }
    }
}
