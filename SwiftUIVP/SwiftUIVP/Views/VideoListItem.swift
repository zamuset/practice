//
//  VideoListItem.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 17/06/24.
//

import SwiftUI

struct VideoListItem: View {
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                // Replace with thumbnail
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.blue)
                
                Image(systemName: "play.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .shadow(radius: 4)
                
                Text("11:40")
                    .foregroundStyle(.red)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 80, alignment: .bottomTrailing)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("video title")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundStyle(Color.accentColor)
                
                Text("video description that can take up to 2 lines but no more because then the text will be truncated")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2, reservesSpace: true)
            }
            
        }
    }
}

#Preview {
    VideoListItem()
}
