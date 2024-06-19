//
//  VideoItem.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import SwiftUI

struct VideoItem: View {
    let video: Video
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                AsyncImage(url: video.image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: 300, maxHeight: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .shadow(radius: 4)
                    .foregroundStyle(.white)
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
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3, reservesSpace: true)
                
                Text(video.duration.formatedDuration())
                    .foregroundStyle(Color.accentColor)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    VideoItem(video: Video.testVideo)
        .previewLayout(.sizeThatFits)
        .padding()
}
