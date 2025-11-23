//
//  ContentView.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var moviesViewModel = MoviesViewModel()
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            TabView {
                MoviesListView(viewModel: moviesViewModel)
                    .tabItem {
                        Label("Movies", systemImage: "film")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .opacity(showSplash ? 0 : 1)
            
            if showSplash {
                SimpleLoadingView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .onAppear {
            if moviesViewModel.movies.isEmpty {
                moviesViewModel.loadPopularMovies()
            }
            
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                
                withAnimation(.easeOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
   ContentView()
        .environmentObject(FavoritesManager(viewContext: PersistenceController.preview.container.viewContext))
}
