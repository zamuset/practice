//
//  VideoPlayerView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State var player = AVPlayer()
    @State var currentPlayingVideo: VideoFile
    @State var showFullScreen = false
    let action: (Bool) -> Void
    
    var body: some View {
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
                    Image(systemName: "arrow.down.left.and.arrow.up.right")
                        .padding(16)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .onTapGesture {
                            showFullScreen.toggle()
                            action(showFullScreen)
                        }
                }
                Spacer()
            }
        }
        .onAppear {
            Task {
                player = AVPlayer(url: currentPlayingVideo.link)
                player.play()
            }
        }
        .onDisappear {
            player.pause()
        }
    }
}

#Preview {
    VideoPlayerView(currentPlayingVideo: .testVideoFile, action: { _ in })
}
