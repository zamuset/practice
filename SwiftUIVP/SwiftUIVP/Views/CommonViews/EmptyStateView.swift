//
//  EmptyStateView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 21/06/24.
//

import SwiftUI

struct EmptyStateView: View {
    var imageName: String
    var title: String
    var message: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 10)

            Text(message)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}

#Preview {
    EmptyStateView(imageName: "exclamationmark.circle", title: "No Data Available", message: "There is currently no data to display. Please check back later or try refreshing the view.")
}
