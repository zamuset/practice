//
//  VideoListModel.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import Foundation

struct VideoList: Decodable {
    var page: Int?
    var perPage: Int?
    var totalResults: Int?
    var url: URL?
    var videos: [Video]
}
