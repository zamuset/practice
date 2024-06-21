//
//  MainView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var sharedStatus: SharedStatus
    let viewContext = PersistenceController.shared.container.viewContext
    var body: some View {
        TabView {
            if sharedStatus.isOnline {
                VideoListView(context: viewContext)
                    .tabItem {
                        Image(systemName: "video")
                        Text("Videos")
                    }
                    .tag(1)
            }
            
            SavedVideosView(context: viewContext)
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Saved Videos")
                }
                .tag(2)
        }
        .onReceive(NotificationCenter.default.publisher(for: .connectivityStatus),
                   perform: { notification in
            if let isConnected = notification.object as? Bool {
                sharedStatus.isOnline = isConnected
            }
        })
    }
}

#Preview {
    MainView()
        .environmentObject(SharedStatus())
}
