//
//  MainView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI

struct MainView: View {
    
    @State var showOnlineVideos = true
    
    var body: some View {
        TabView {
            if showOnlineVideos {
                VideoListView(context: PersistenceController.shared.container.viewContext)
                    .tabItem {
                        Image(systemName: "video")
                        Text("Videos")
                    }
                    .tag(1)
            }
            
            SavedVideosView(context: PersistenceController.shared.container.viewContext)
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Saved Videos")
                }
                .tag(2)
        }
        .onReceive(NotificationCenter.default.publisher(for: .connectivityStatus),
                   perform: { notification in
            if let isConnected = notification.object as? Bool {
                showOnlineVideos = isConnected
            }
        })
    }
}

#Preview {
    MainView()
}
