//
//  ViewModel.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import SwiftUI
import Combine
import CoreData

enum APIErrorType: Error {
    case invalidURL
    case errorResponse
    case errorParsingData
    case invalidRequest
    case dataNotFound
}

final class ViewModel: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var videoList: VideoList = VideoList(videos: [])
    @Published var videos: [Video] = []
    @Published var showError = false
    var cancellables = Set<AnyCancellable>()
    
    // Video download and persistence
    var viewContext: NSManagedObjectContext
    @Published var progress: Float = 0
    private var videoName: String = ""
    private var authorInfo: (user: String, description: String) = (user: "", description: "")
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
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

// Video download and persistence
extension ViewModel {
    func downloadVideo(url: URL, authorInfo: (user: String, description: String)) {
        videoName = url.lastPathComponent
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return
            }
            let downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            return
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(videoName)
        do {
            try data.write(to: destinationURL)
            storeVideo(at: destinationURL)
        } catch {
            debugPrint("Error saving file:", error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
    
    func storeVideo(at path: URL) {
        let savedVideoEntity = SavedVideo(context: viewContext)
        savedVideoEntity.id = UUID()
        savedVideoEntity.localPath = path.absoluteString
        savedVideoEntity.name = videoName
        savedVideoEntity.author = authorInfo.user
        savedVideoEntity.authorInfo = authorInfo.description
        
        do {
            try viewContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

