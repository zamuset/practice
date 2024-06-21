//
//  Persistence.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 16/06/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUIVP")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            // For debug purposes
            debugPrint(storeDescription.getDatabaseLocation() ?? "No database location")
            if let error = error as NSError? {
                debugPrint("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                let nserror = error as NSError
                debugPrint("Unresolved error \(error), \(nserror.userInfo)")
            }
        }
    }
}

extension NSPersistentStoreDescription {
    func getDatabaseLocation() -> String? {
        return self
            .url?
            .absoluteString
            .removingPercentEncoding
    }
}

