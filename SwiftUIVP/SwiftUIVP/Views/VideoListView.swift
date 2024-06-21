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
    @ObservedObject var viewModel: ViewModel
    @State private var animateGradient: Bool = false
    private let startColor: Color = .blue
    private let middleColor: Color = .yellow
    private let endColor: Color = .green
    
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.viewModel = ViewModel(context: context)
    }
        
    var body: some View {
        NavigationView {
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
            .navigationTitle("Videos")
            .scrollContentBackground(.hidden)
            .background {
                LinearGradient(colors: [startColor, middleColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea(.all)
                    .hueRotation(.degrees(animateGradient ? 45 : 0))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                    }
            }
            .task {
                do {
                    try await viewModel.getPopularVideos()
                } catch {
                    debugPrint("error", error.localizedDescription)
                }
            }
        } // Navigation
    }
}

#Preview {
    VideoListView(context: PersistenceController.shared.container.viewContext)
}
