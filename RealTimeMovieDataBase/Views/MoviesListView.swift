//
//  MoviesListView.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI
import CoreData

struct MoviesListView: View {
    @ObservedObject var viewModel: MoviesViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                if let errorMessage = viewModel.errorMessage, viewModel.movies.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            viewModel.refresh()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                    MovieCardView(
                                        movie: movie,
                                        isFavorite: favoritesManager.isFavorite(movieId: movie.id),
                                        onFavoriteTap: {
                                            favoritesManager.toggleFavorite(movie: movie)
                                        }
                                    )
                                }
                                .buttonStyle(ScaleButtonStyle())
                                .onAppear {
                                    if viewModel.shouldLoadMore(currentItem: movie) {
                                        viewModel.loadMoreMovies()
                                    }
                                }
                            }
                            
                            if viewModel.isLoadingMore {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .padding()
                                    Spacer()
                                }
                                .gridCellColumns(2)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchQuery, prompt: "Search movies")
        }
    }
}

#Preview {
    MoviesListView(viewModel: MoviesViewModel())
        .environmentObject(FavoritesManager(viewContext: PersistenceController.preview.container.viewContext))
}
