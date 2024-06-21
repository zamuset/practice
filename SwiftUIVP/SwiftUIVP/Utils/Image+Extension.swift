//
//  Image+Extension.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 21/06/24.
//

import SwiftUI

extension Image {
    func imageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
    }

    func thumbnailModifier() -> some View {
        self
            .imageModifier()
            .aspectRatio(contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .containerRelativeFrame(.horizontal) { size, axis in
                size * 0.4
            }
    }
}
