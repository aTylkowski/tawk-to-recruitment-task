//
//  tawk_to_appTests.swift
//  tawk.to.appTests
//
//  Created by Aleksy Tylkowski on 26/07/2024.
//

import XCTest
import CoreData

final class tawk_to_appTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockRequestManager: MockRequestManager!
    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockRequestManager = MockRequestManager()
        mockCoreDataManager = MockCoreDataManager()
        viewModel = MainViewModel(requestManager: mockRequestManager, coreDataManager: mockCoreDataManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRequestManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testFetchEntryUsersSuccess() {
        // Given
        let mockUsers = [UserInfo(id: 1, username: "user1", score: 10.0, profileImageUrl: "url1", organizationsUrl: "url1"),
                         UserInfo(id: 2, username: "user2", score: 20.0, profileImageUrl: "url2", organizationsUrl: "url2")]
        mockRequestManager.mockData = try? JSONEncoder().encode(mockUsers)
        
        let expectation = self.expectation(description: "Data updated")
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }
        
        // When
        viewModel.fetchEntryUsers()
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.users.count, mockUsers.count)
        XCTAssertEqual(viewModel.users.first?.username, mockUsers.first?.username)
    }
    
    func testFetchEntryUsersFailure() {
        // Given
        mockRequestManager.mockError = NSError(domain: "test", code: 1, userInfo: nil)
        
        let expectation = self.expectation(description: "Data updated")
        viewModel.onDataUpdated = {
            expectation.fulfill()
        }
        
        // When
        viewModel.fetchEntryUsers()
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testSaveUser() {
        // Given
        let context = mockCoreDataManager.mainContext
        let userInfo = UserInfo(id: 1, username: "user1", score: 10.0, profileImageUrl: "url1", organizationsUrl: "url1")

        let expectation = self.expectation(description: "Core Data Save")

        // When
        viewModel.saveUsersToCoreData(users: [userInfo])

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            let fetchRequest: NSFetchRequest<UserInfoEntity> = UserInfoEntity.fetchRequest()
            do {
                let results = try context.fetch(fetchRequest)
                XCTAssertEqual(results.count, 1)
            } catch {
                XCTFail("Fetch failed with error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
