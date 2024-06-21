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
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.viewModel = ViewModel(context: context)
    }
    
    var body: some View {
        List(viewModel.videos) { video in
            VideoItem(video: video)
                .background(
                    NavigationLink("", destination:
                                    VideoDetailView(context: viewContext,
                                                    video: video,
                                                    currentPlaying: video.fistStandardVideo))
                    .buttonStyle(.plain)
                    .opacity(0)
                )
                .buttonStyle(.plain)
        } // List
        
        .listStyle(.insetGrouped)
        .navigationTitle("Saved videos")
        .scrollContentBackground(.hidden)
        .task {
            do {
                try await viewModel.getStoredVideos()
            } catch {
                debugPrint("error", error.localizedDescription)
            }
        }
    }
}

#Preview {
    SavedVideosView(context: PersistenceController.shared.container.viewContext)
}
