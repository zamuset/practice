//
//  SavedVideo+CoreDataProperties.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 19/06/24.
//
//

import Foundation
import CoreData


extension SavedVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedVideo> {
        return NSFetchRequest<SavedVideo>(entityName: "SavedVideo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var localPath: String?
    @NSManaged public var name: String?
    @NSManaged public var author: String?
    @NSManaged public var authorInfo: String?

}

extension SavedVideo : Identifiable {

}
