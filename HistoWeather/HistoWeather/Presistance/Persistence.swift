//
//  Persistence.swift
//  iOS Architecture Example
//
//  Created by INSO on 05.10.21.


import CoreData

/**
 `CoreData` and therefore persistence access layer.
 
 Offers a `PersistenceController` to access the persistence context. It is possible for view previews and
 testing to only create an in memory database.
 */
class PersistenceController {

    static let shared = PersistenceController()

    /**
     # Core Data's View Context
     
     The database context for views and the main thread. Use this context for
     all UI related data access.
     */
    lazy var viewContext = container.viewContext

    /**
     # Core Data's Background Context
     
     The database context for operations in the background. Use this context
     for operations which should **not** happen on the main thread such as:
     
     - Creation of managed objects
     - Any manipulation of managed objects
     - Any other database operations which are not related to the UI
     */
    lazy var backgroundContext: NSManagedObjectContext = {
        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HistoWeather")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it
                // may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection
                  when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        // Needed to merge the changes on the background context to the view context
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

extension NSManagedObjectContext {

    func saveContext() {
        if hasChanges {
            do {
                try save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//extension PersistenceController {
//
//    /// Only used for SwiftUI previews, **do not use this otherwise**
//    /// Adds a list of `Item` to the an in memory `CoreData` context.
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<4 {
//            let newItem = Friend(context: viewContext)
//            newItem.name = generateRandomName()
//            newItem.bestFriendScore = Int16(generateRandomBestFriendScore())
//        }
//        return result
//    }()
//}
