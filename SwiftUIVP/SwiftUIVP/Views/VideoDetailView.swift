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
    
    var body: some View {
        VStack {
            videoView.frame(height: 350)
        }.fullScreenCover(isPresented: $showFullScreen, content: {
            videoView.padding(.vertical, 10)
        })
    }
    
    @ViewBuilder
    private var videoView: some View {
        VideoPlayer(player: player) {
            VStack {
                HStack {
                    Spacer()
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
            if let sdVideo = video.videoFiles.first(where: { $0.quality == "sd" }) {
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
    VideoDetailView(video: Video.testVideo)
}
