//
//  VideoInfo.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 21/06/24.
//

import Foundation

struct VideoInfo: Identifiable {
    let id: Int = UUID().hashValue
    let imageName: String
    let text: String
}
