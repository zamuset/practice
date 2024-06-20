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
        VStack(spacing: 10) {
            ZStack {
                AsyncImage(url: video.image) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: 400, maxHeight: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .shadow(radius: 4)
                    .foregroundStyle(.white)
                
            }
            // Save offline button
//            .overlay(
//                Button(action: {
//                    // Implement download
//                }, label: {
//                    Image(systemName: "bookmark")
//                        .foregroundStyle(.accent)
//                }),
//                alignment: .topTrailing
//            )
            // Duration text
            .overlay(
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 12)
                    Text(video.duration.formatedDuration())
                }
                    .padding(.horizontal, 4)
                    .background(.black.opacity(0.5))
                    .foregroundStyle(.white)
                    .font(.footnote)
                    .fontWeight(.light),
                alignment: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text(video.user.name)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.accentColor)
                
                Text("You can check my profile in the link below\n[\(video.user.url.lastPathComponent)](\(video.user.url.absoluteString))")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3, reservesSpace: true)
            }
        }
    }
}

#Preview {
    VideoItem(video: Video.testVideo)
        .previewLayout(.sizeThatFits)
        .padding()
}
