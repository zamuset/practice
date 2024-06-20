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
}

extension NSPersistentStoreDescription {
    func getDatabaseLocation() -> String? {
        return self
            .url?
            .absoluteString
            .replacingOccurrences(of: "%20", with: "\\ ")
    }
}
