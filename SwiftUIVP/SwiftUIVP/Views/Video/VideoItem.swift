//
//  VideoItem.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import SwiftUI

struct VideoItem: View {
    let video: Video
    @State var image: UIImage?
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .thumbnailModifier()
                } else {
                    AsyncImage(url: video.image) { image in
                        image
                            .thumbnailModifier()
                    } placeholder: {
                        ProgressView()
                            .containerRelativeFrame(.horizontal) { size, axis in
                                size * 0.4
                            }
                    }
                }
                
                Image(systemName: "play.circle")
                    .imageModifier()
                    .frame(height: 32)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(video.user.name)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.accentColor)
                
                Text("My page: [\(video.user.url.lastPathComponent)](\(video.user.url.absoluteString))")
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3, reservesSpace: true)
                
                SubDetailView(items: [
                    .init(imageName: "clock", text: video.duration.formatedDuration()),
                    .init(imageName: "video", text: video.fistStandardVideo.quality.uppercased())
                ])
            }
        }
    }
}

#Preview {
    VideoItem(video: Video.testVideo)
        .previewLayout(.sizeThatFits)
        .padding()
}
