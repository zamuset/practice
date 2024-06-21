//
//  VideoModel.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import Foundation

struct Video: Decodable, Identifiable {
    let id: Int
    let width: Int?
    let height: Int?
    let url: URL
    let image: URL
    let duration: Int
    let user: User
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]
}

struct User: Decodable {
    let id: Int
    let name: String
    let url: URL
}

struct VideoFile: Decodable, Identifiable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int?
    let height: Int?
    let link: URL
}

struct VideoPicture: Decodable, Identifiable {
    let id: Int
    let picture: URL
    let nr: Int
}

extension Video {
    static var testVideo: Video {
        return .init(id: 1, 
                     width: 1080,
                     height: 1920,
                     url: URL(string: "https://www.pexels.com/video/2499611/")!, 
                     image: URL(string: "https://images.pexels.com/videos/2499611/free-video-2499611.jpg?fit=crop&w=1200&h=630&auto=compress&cs=tinysrgb")!,
                     duration: 2234,
                     user: .init(id: 123, name: "Test user", url: URL(string: "https://www.pexels.com/@joey")!),
                     videoFiles: [
                        VideoFile.testVideoFile
                     ],
                     videoPictures: [
                        VideoPicture.testVideoPicture
                     ])
    }
    
    var fistStandardVideo: VideoFile {
        return videoFiles.first(where: { $0.quality == "sd" }) ?? .testVideoFile
    }
}

extension VideoFile {
    static var testVideoFile: VideoFile {
        return .init(id: 456,
                     quality: "sd",
                     fileType: "video/mp4",
                     width: 360,
                     height: 640,
                     link: URL(string: "https://player.vimeo.com/external/342571552.sd.mp4?s=e0df43853c25598dfd0ec4d3f413bce1e002deef&profile_id=164&oauth2_token_id=57447761")!)
    }
}

extension VideoPicture {
    static var testVideoPicture: VideoPicture {
        return .init(id: 789,
                     picture: URL(string: "https://static-videos.pexels.com/videos/2499611/pictures/preview-0.jpg")!,
                     nr: 0)
    }
}
