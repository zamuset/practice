//
//  MainView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            VideoListView(context: PersistenceController.shared.container.viewContext)
                .tabItem {
                    Image(systemName: "video")
                    Text("Videos")
                }
                .tag(1)
            
            EmptyView()
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Downloaded Videos")
                }
                .tag(2)
        }
    }
}

#Preview {
    MainView()
}