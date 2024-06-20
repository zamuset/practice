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
    @Published var isDownloading: Bool = false
    @Published var progress: Float = 0
    @Published var totalSizeDownload: Float = 0
    private var videoToSave: VideoFile = .testVideoFile
    private var authorInfo: (name: String, siteLink: String) = (name: "", siteLink: "")
    
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
    func downloadVideo(_ video: VideoFile, authorInfo: (name: String, siteLink: String)) {
        videoToSave = video
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: video.link) { (data, response, error) in
            guard error == nil else {
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.isDownloading = true
            }
            let downloadTask = session.downloadTask(with: video.link)
            downloadTask.resume()
        }
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            return
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(videoToSave.link.lastPathComponent)
        do {
            try data.write(to: destinationURL)
            storeVideo(at: destinationURL)
        } catch {
            debugPrint("Error saving file:", error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async { [weak self] in
            self?.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            self?.totalSizeDownload = Float(totalBytesExpectedToWrite)
            if totalBytesWritten == totalBytesExpectedToWrite {
                self?.isDownloading = false
            }
        }
    }
    
    private func storeVideo(at path: URL) {
        let savedVideoEntity = SavedVideo(context: viewContext)
        savedVideoEntity.id = "\(videoToSave.id)"
        savedVideoEntity.localPath = path.absoluteString
        savedVideoEntity.name = videoToSave.link.lastPathComponent
        savedVideoEntity.author = authorInfo.name
        savedVideoEntity.authorInfo = authorInfo.siteLink
        
        do {
            try viewContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func removeVideo(with id: String) async throws {
        let request = SavedVideo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let videoToDelete = try viewContext.fetch(request).first {
                try await deleteStoredVideo(video: videoToDelete)
                viewContext.delete(videoToDelete)
                try viewContext.save()
            }
        } catch {
            throw DBErrorType.entityNotFound
        }
    }
    
    private func deleteStoredVideo(video: SavedVideo) async throws {
        guard let fileLocation = URL(string: video.localPath ?? "") else {
            throw DBErrorType.unknown
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent(fileLocation.lastPathComponent)
        
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
            throw error
        }
    }
    
    func checkIfVideoExist(with id: String) async throws -> SavedVideo? {
        let request = SavedVideo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            guard let searchedVideo = try viewContext.fetch(request).first else {
                return nil
            }
            return searchedVideo
        } catch {
            throw DBErrorType.entityNotFound
        }
    }
}

