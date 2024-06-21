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
    @State var savedVideo: SavedVideo? = nil
    @ObservedObject var viewModel: ViewModel
    var video: Video = .testVideo
    let currentPlayingVideo: VideoFile
    @State var selection = 0
    
    init(context: NSManagedObjectContext, video: Video, currentPlaying: VideoFile) {
        self.viewModel = ViewModel(context: context)
        self.video = video
        self.currentPlayingVideo = currentPlaying
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
                    
                    if savedVideo != nil {
                        Button(action: {
                            Task {
                                try await viewModel.removeVideo(with: savedVideo?.id ?? -1)
                            }
                        }, label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        })
                        .foregroundStyle(.red)
                    } else {
                        Button(action: {
                            viewModel.downloadVideo(
                                currentPlayingVideo,
                                extraInfo: .init(name: video.user.name,
                                                 imagePath: video.image,
                                                 siteLink: video.user.url,
                                                 duration: video.duration)
                            )
                        }, label: {
                            Text("Download")
                            Image(systemName: "square.and.arrow.down")
                            
                        })
                    }
                }
                .padding(.horizontal, 8)
                
                VideoPlayerView(currentPlayingVideo: currentPlayingVideo,
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
                                action: { value in showFullScreen = value })
                    .ignoresSafeArea(.all)
            })
            
            if viewModel.isDownloading {
                LoaderView()
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return VideoDetailView(context: context, video: Video.testVideo, currentPlaying: .testVideoFile)
    
}
