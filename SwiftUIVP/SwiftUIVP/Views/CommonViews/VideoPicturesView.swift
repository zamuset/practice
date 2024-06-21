//
//  VideoPicturesView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 19/06/24.
//

import SwiftUI

struct VideoPicturesView: View {
    let videoPictures: [VideoPicture]
    @State private var gridLayout: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 30) {
                LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                    ForEach(videoPictures) { item in
                        AsyncImage(url: item.picture) { image in
                            image
                                .imageModifier()
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                        } placeholder: {
                            Image(systemName: "photo.stack")
                                .imageModifier()
                        }
                    }
                }
                .onAppear {
                    withAnimation(.easeIn) {}
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 50)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    let videoPictures: [VideoPicture] = Array(repeating: VideoPicture.testVideoPicture, count: 16)
    return VideoPicturesView(videoPictures: videoPictures)
}
