//
//  SubDetailView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 21/06/24.
//

import SwiftUI

struct SubDetailView: View {
    let items: [VideoInfo]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(items) { item in
                HStack {
                    Image(systemName: item.imageName)
                        .imageModifier()
                        .frame(height: 12)
                    Text(item.text)
                }
                .padding(4)
                .background(.white.opacity(0.5))
                .foregroundStyle(.white)
                .font(.footnote)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

#Preview {
    SubDetailView(items: [
        .init(imageName: "clock", text: "10:33"),
        .init(imageName: "video", text: "hd")
    ])
}
