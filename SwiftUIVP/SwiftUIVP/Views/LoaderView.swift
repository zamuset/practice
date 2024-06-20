//
//  LoaderView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        VStack {
            VStack {
                ProgressView()
                    .padding(.horizontal, 12)
                    .tint(.accentColor)
                    .scaleEffect(5)
                Text("Processing...")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .fontWeight(.heavy)
                    .padding(.top, 80)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.6).ignoresSafeArea(.all))
        }
    }
}

#Preview {
    LoaderView()
}
