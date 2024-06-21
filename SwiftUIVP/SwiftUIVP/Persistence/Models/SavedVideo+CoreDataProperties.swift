//
//  SavedVideo+CoreDataProperties.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//
//

import Foundation
import CoreData


extension SavedVideo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedVideo> {
        return NSFetchRequest<SavedVideo>(entityName: "SavedVideo")
    }

    @NSManaged public var authorName: String?
    @NSManaged public var authorSite: URL?
    @NSManaged public var id: Int64
    @NSManaged public var videoPath: URL?
    @NSManaged public var videoName: String?
    @NSManaged public var imagePath: URL?
    @NSManaged public var duration: Int64

}

extension SavedVideo : Identifiable {
    func toVideo() -> Video? {
        guard let videoPath = videoPath,
              let imagePath = imagePath,
              let authorSite = authorSite else {
            return nil
        }
        return Video(id: id.toInt,
                     width: nil,
                     height: nil,
                     url: videoPath,
                     image: imagePath,
                     duration: duration.toInt,
                     user: .init(id: 0, name: authorName ?? "", url: authorSite),
                     videoFiles: [.init(id: id.toInt, quality: "sd", fileType: "", width: nil, height: nil, link: videoPath)],
                     videoPictures: [])
    }
}
