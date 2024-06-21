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
    @Published var savedVideo: SavedVideo? = nil
    @Published var isDownloading: Bool = false
    @Published var progress: Float = 0
    @Published var totalSizeDownload: Float = 0
    private var videoToSave: VideoFile = .testVideoFile
    private var extraInfo: VideoExtraInfo = .init()
    
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
    @MainActor
    func downloadVideo(_ video: VideoFile, extraInfo: VideoExtraInfo) {
        videoToSave = video
        self.extraInfo = extraInfo
        downloadImage(from: extraInfo.imagePath)
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
    
    func downloadImage(from url: URL?) {
        Task {
            guard let url = url else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
            
            if FileManager.default.createFile(atPath: destinationURL.path(), contents: data) {
                extraInfo.imagePath = destinationURL
            }
        }
    }
    
    func loadImage(from path: URL) -> UIImage? {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(path.lastPathComponent)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
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
    
    @MainActor
    func getStoredVideos() async throws {
        let request = SavedVideo.fetchRequest()
        
        do {
            let storedVideos = try viewContext.fetch(request)
            videos = storedVideos.compactMap { $0.toVideo() }
        } catch {
            throw DBErrorType.entityNotFound
        }
    }
    
    private func storeVideo(at path: URL) {
        let savedVideoEntity = SavedVideo(context: viewContext)
        savedVideoEntity.id = videoToSave.id.toInt64
        savedVideoEntity.imagePath = extraInfo.imagePath
        savedVideoEntity.videoName = videoToSave.link.lastPathComponent
        savedVideoEntity.videoPath = path
        savedVideoEntity.duration = extraInfo.duration?.toInt64 ?? 0
        savedVideoEntity.authorName = extraInfo.name
        savedVideoEntity.authorSite = extraInfo.siteLink
                
        do {
            try viewContext.save()
            Task {
                try? await checkIfStored(video: videoToSave.id.toInt64)
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @MainActor
    func removeVideo() async throws {
        let id = savedVideo?.id ?? -1
        let request = SavedVideo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let videoToDelete = try viewContext.fetch(request).first {
                try await deleteStoredVideo(video: videoToDelete)
                viewContext.delete(videoToDelete)
                try viewContext.save()
                savedVideo = nil
            }
        } catch {
            throw error
        }
    }
    
    private func deleteStoredVideo(video: SavedVideo) async throws {
        guard let fileLocation = video.videoPath else {
            throw DBErrorType.unknown
        }
        
        do {
            try FileManager.default.removeItem(at: fileLocation)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func checkIfStored(video id: Int64) async throws {
        let request = SavedVideo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let searchedVideo = try viewContext.fetch(request).first {
                savedVideo = searchedVideo
            }
        } catch {
            throw DBErrorType.entityNotFound
        }
    }
}

