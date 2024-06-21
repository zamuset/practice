//
//  VideoDetailView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 18/06/24.
//

import SwiftUI
import AVKit
import CoreData

struct VideoDetailView: View {
    @State var showFullScreen = false
    @ObservedObject var viewModel: ViewModel
    var video: Video = .testVideo
    let currentPlayingVideo: VideoFile
    var playLocalVideo: Bool
    @State var selection = 0
    
    init(context: NSManagedObjectContext, video: Video, 
         currentPlaying: VideoFile, playLocalVideo: Bool) {
        self.viewModel = ViewModel(context: context)
        self.video = video
        self.currentPlayingVideo = currentPlaying
        self.playLocalVideo = playLocalVideo
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("This video ID is \(currentPlayingVideo.id)")
                        .foregroundStyle(.accent)
                        .font(.headline)
                        .padding(.horizontal, 12)
                    Spacer()
                    
                    Button(action: {
                        if viewModel.savedVideo != nil {
                            Task {
                                try await viewModel.removeVideo()
                            }
                        } else {
                            viewModel.downloadVideo(
                                currentPlayingVideo,
                                extraInfo: .init(name: video.user.name,
                                                 imagePath: video.image,
                                                 siteLink: video.user.url,
                                                 duration: video.duration))
                        }
                    }, label: {
                        if viewModel.savedVideo != nil {
                            Text("Delete")
                            Image(systemName: "trash")
                        } else {
                            Text("Download")
                            Image(systemName: "square.and.arrow.down")
                        }
                        
                    })
                    .foregroundStyle(viewModel.savedVideo != nil ? .red : .green)
                }
                .padding(.horizontal, 8)
                
                VideoPlayerView(currentPlayingVideo: currentPlayingVideo,
                                playLocalVideo: playLocalVideo,
                                action: { value in showFullScreen = value })
                    .frame(height: 350)
                
                Picker(selection: $selection, label: Text("Test")) {
                    Text("Other videos").tag(0)
                    Text("Pictures").tag(1)
                }
                .pickerStyle(.segmented)
                .background(.green.opacity(0.5))
                
                switch selection {
                case 1:
                    VideoPicturesView(videoPictures: video.videoPictures)
                default:
                    Text("View one")
                }
                Spacer()
            }
            .fullScreenCover(isPresented: $showFullScreen, content: {
                VideoPlayerView(currentPlayingVideo: currentPlayingVideo,
                                playLocalVideo: playLocalVideo,
                                action: { value in showFullScreen = value })
                    .ignoresSafeArea(.all)
            })
            .task {
                try? await viewModel.checkIfStored(video: currentPlayingVideo.id.toInt64)
            }
            
            if viewModel.isDownloading {
                LoaderView()
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return VideoDetailView(context: context, video: Video.testVideo, currentPlaying: .testVideoFile, playLocalVideo: false)
    
}
