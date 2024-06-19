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
    @State private var animateGradient: Bool = false
    private let startColor: Color = .blue
    private let middleColor: Color = .yellow
    private let endColor: Color = .green
    
    var body: some View {
        NavigationView {
            List(viewModel.videos) { video in
                VideoItem(video: video)
                    .background(
                        NavigationLink("", destination: VideoDetailView(video: video)).opacity(0)
                    )
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
                    print("error", error.localizedDescription)
                }
            }
        } // Navigation
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
