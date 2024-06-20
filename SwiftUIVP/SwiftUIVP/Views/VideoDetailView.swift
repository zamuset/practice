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
    @State var player = AVPlayer()
    @State var showFullScreen = false
    @State var currentPlayingVideo: VideoFile = .testVideoFile
    @State var savedVideo: SavedVideo? = nil
    @ObservedObject var viewModel: ViewModel
    let video: Video
    
    @State var selection = 0
    
    init(context: NSManagedObjectContext, video: Video) {
        self.viewModel = ViewModel(context: context)
        self.video = video
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
                                try await viewModel.removeVideo(with: savedVideo?.id ?? "")
                            }
                        }, label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        })
                        .foregroundStyle(.red)
                    } else {
                        Button(action: {
                            viewModel.downloadVideo(currentPlayingVideo,
                                                    authorInfo: (name: video.user.name,
                                                                 siteLink: video.user.url.absoluteString)
                            )
                        }, label: {
                            Text("Download")
                            Image(systemName: "square.and.arrow.down")
                            
                        })
                    }
                }
                .padding(.horizontal, 8)
                
                videoView
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
                videoView
                    .ignoresSafeArea(.all)
            })
            
            if viewModel.isDownloading {
                LoaderView()
            }
        }
    }
    
    @ViewBuilder
    private var videoView: some View {
        VideoPlayer(player: player) {
            VStack {
                HStack {
                    Spacer()
                    // Video quality label
                    Text(currentPlayingVideo.quality.uppercased())
                        .padding(.horizontal, 2)
                        .background(.white.opacity(0.5))
                        .foregroundStyle(.white)
                        .font(.system(.footnote, design: .rounded))
                        .fontWeight(.heavy)
                    // Full Screen toogle button
                    let imageName = showFullScreen ?
                        "arrow.down.right.and.arrow.up.left" :
                        "arrow.up.left.and.arrow.down.right"
                    Image(systemName: imageName)
                        .padding(16)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .onTapGesture {
                            showFullScreen.toggle()
                        }
                }
                Spacer()
            }
        }
        .onAppear {
            // Unwrap the first standard definition video from the list
            if let sdVideo = video.videoFiles.first(where: { $0.quality == "sd" }) {
                currentPlayingVideo = sdVideo
                player = AVPlayer(url: sdVideo.link)
                player.play()
            }
            
        }
        .onDisappear {
            player.pause()
        }
        .task {
            if let sdVideo = video.videoFiles.first(where: { $0.quality == "sd" }) {
                do {
                    savedVideo = try await viewModel.checkIfVideoExist(with: "\(sdVideo.id)")
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    return VideoDetailView(context: context, video: Video.testVideo)
    
}
