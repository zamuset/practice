//
//  VideoDetailView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 18/06/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    let video: Video
    @State var player = AVPlayer()
    @State var showFullScreen = false
    @State var currentVideo: VideoFile = .testVideoFile
    
    @State var selection = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("This video ID is \(currentVideo.id)")
                .foregroundStyle(.accent)
                .font(.headline)
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
                .padding(.vertical, 10)
        })
        .onAppear {
            if let sdVideo = video.videoFiles.first(where: { $0.quality == "sd" }) {
                currentVideo = sdVideo
                player = AVPlayer(url: sdVideo.link)
                player.play()
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
                    Text(currentVideo.quality.uppercased())
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
                currentVideo = sdVideo
                player = AVPlayer(url: sdVideo.link)
                player.play()
            }
        }
        .onDisappear {
            player.pause()
        }
    }
}

#Preview {
    VideoDetailView(video: Video.testVideo, currentVideo: VideoFile.testVideoFile)
}
