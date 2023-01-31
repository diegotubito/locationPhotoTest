//
//  TestCoreDataStack.swift
//  photoLocationTestTests
//
//  Created by Gomez David Diego on 31/01/2023.
//

import CoreData

class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        
        let container = NSPersistentContainer(name: "Photo")
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
