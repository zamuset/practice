//
//  ContentView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 16/06/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.videos) { video in
                NavigationLink(destination: VideoDetailView(video: video)) {
                    VideoItem(video: video)
                        .padding(.vertical, 8)
                }
            } // List
            .listStyle(.insetGrouped)
            .navigationTitle("Videos")
            .task {
                do {
                    try await viewModel.getPopularVideos()
                } catch {
                    print("error", error.localizedDescription)
                }
            }
        } // Navigation
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
