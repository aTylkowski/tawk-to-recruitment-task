//
//  MockedCoreDataManager.swift
//  tawk.to.appTests
//
//  Created by Aleksy Tylkowski on 26/07/2024.
//

import Foundation
import CoreData

final class MockCoreDataManager: CoreDataManager {
    override init() {
        super.init()
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: "Model")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        persistentContainer = container
    }
}
