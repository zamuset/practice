//
//  VideoListView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI
import CoreData

struct VideoListView: View {
    private var viewContext: NSManagedObjectContext
    @EnvironmentObject var sharedStatus: SharedStatus
    @ObservedObject var viewModel: ViewModel
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.viewModel = ViewModel(context: context)
    }
        
    var body: some View {
        NavigationView {
            if viewModel.videos.isEmpty {
                EmptyStateView(imageName: "sparkle.magnifyingglass", title: "There was an error", message: "")
                    .task {
                        do {
                            try await viewModel.getPopularVideos()
                        } catch {
                            debugPrint("error", error.localizedDescription)
                        }
                    }
            } else {
                List(viewModel.videos) { video in
                    VideoItem(video: video)
                        .background(
                            NavigationLink("", destination:
                                            VideoDetailView(context: viewContext,
                                                            video: video,
                                                            currentPlaying: video.fistStandardVideo,
                                                            playLocalVideo: false))
                            .buttonStyle(.plain)
                            .opacity(0)
                        )
                } // List
                .listStyle(.insetGrouped)
                .navigationTitle("Videos")
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        let imageName = sharedStatus.isOnline ? "wifi" : "wifi.slash"
                        Image(systemName: imageName)
                            .foregroundStyle(sharedStatus.isOnline ? .accent : .red)
                    }
                }
            }
        } // Navigation
    }
}

#Preview {
    VideoListView(context: PersistenceController.shared.container.viewContext)
        .environmentObject(SharedStatus())
}
