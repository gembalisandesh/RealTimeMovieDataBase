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
                        .padding(.top, 70)
                        .padding(.bottom, 8)
                    }
                    .refreshable {
                        viewModel.refresh()
                    }
                }
                
                VStack {
                    FloatingSearchBar(searchText: $viewModel.searchQuery)
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    Spacer()
                }

            }
            .navigationTitle("Movies")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FloatingSearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 16))
                
                TextField("Search movies", text: $searchText)
                    .focused($isFocused)
                    .foregroundColor(.primary)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            colorScheme == .dark
                                                ? Color.white.opacity(0.3)
                                                : Color.black.opacity(0.2),
                                            colorScheme == .dark
                                                ? Color.white.opacity(0.1)
                                                : Color.black.opacity(0.05)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
            )
            
            if isFocused {
                Button {
                    searchText = ""
                    isFocused = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .foregroundColor(.primary)
                        .font(.system(size: 20, weight: .medium))
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isFocused)
    }
}

#Preview {
    MoviesListView(viewModel: MoviesViewModel())
        .environmentObject(FavoritesManager(viewContext: PersistenceController.preview.container.viewContext))
}
