//
//  ViewModel.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import Foundation
import SwiftUI
import Combine

enum APIErrorType: Error {
    case invalidURL
    case errorResponse
    case errorParsingData
    case invalidRequest
    case dataNotFound
}

final class ViewModel: ObservableObject {
    
    @Published var videoList: VideoList = VideoList(videos: [])
    @Published var videos: [Video] = []
    @Published var showError = false
    var cancellables = Set<AnyCancellable>()
    
    @MainActor
    func getPopularVideos() async throws {
        guard let url = URL(string: "https://api.pexels.com/videos/popular?per_page=10") else {
            throw APIErrorType.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("VnugoxffojfDFW5kkNPvmzhY2pkY4aYdlMZILJySDDQIWnGDluhlx4Eg", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpMethod = "GET"
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIErrorType.errorResponse
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decodedVideos = try jsonDecoder.decode(VideoList.self, from: data)
            videoList = decodedVideos
            videos = videoList.videos
        } catch {
            throw APIErrorType.errorParsingData
        }
    }
}
