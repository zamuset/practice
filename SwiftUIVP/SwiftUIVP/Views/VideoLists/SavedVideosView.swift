//
//  SavedVideosView.swift
//  SwiftUIVP
//
//  Created by Samuel Chavez on 20/06/24.
//

import SwiftUI
import CoreData

struct SavedVideosView: View {
    private var viewContext: NSManagedObjectContext
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var sharedStatus: SharedStatus
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.viewModel = ViewModel(context: context)
    }
    
    var body: some View {
        NavigationView {
            if viewModel.videos.isEmpty {
                EmptyStateView(imageName: "tray", title: "There are no saved videos", message: "")
                    .task {
                        do {
                            try await viewModel.getStoredVideos()
                        } catch {
                            debugPrint("error", error.localizedDescription)
                        }
                    }
            } else {
                List(viewModel.videos) { video in
                    VideoItem(video: video, image: viewModel.loadImage(from: video.image))
                        .background(
                            NavigationLink("", destination:
                                            VideoDetailView(context: viewContext,
                                                            video: video,
                                                            currentPlaying: video.fistStandardVideo,
                                                            playLocalVideo: true))
                            .buttonStyle(.plain)
                            .opacity(0)
                        )
                } // List
                .listStyle(.insetGrouped)
                .navigationTitle("Saved videos")
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        let imageName = sharedStatus.isOnline ? "wifi" : "wifi.slash"
                        Image(systemName: imageName)
                            .foregroundStyle(sharedStatus.isOnline ? .accent : .red)
                    }
                }
            }
        }
    }
}

#Preview {
    SavedVideosView(context: PersistenceController.shared.container.viewContext)
        .environmentObject(SharedStatus())
}
