//
//  VideoListItem.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import SwiftUI

struct VideoListItem: View {
    @Environment(\.openURL) private var openURL
    let video: Video
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                AsyncImage(url: video.image) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                } placeholder: {
                    Image(systemName: "video.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .foregroundStyle(.gray)
                }
                
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .shadow(radius: 4)
                    .foregroundStyle(.white)
                
                Text(video.duration.formatedDuration())
                    .foregroundStyle(.white)
                    .frame(width: 150, height: 80, alignment: .topLeading)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(video.user.name)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.accentColor)
                
                Text("You can check my profile in the link below [\(video.user.url.lastPathComponent)](\(video.user.url.absoluteString))")
                    .environment(\.openURL, OpenURLAction { url in
                        return .systemAction(url)
                    })
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: true)
            }
            
        }
    }
}

#Preview {
    VideoListItem(video: Video.testVideo)
}
