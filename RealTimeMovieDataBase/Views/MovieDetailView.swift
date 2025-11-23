//
//  MovieDetailView.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI
import CoreData

struct MovieDetailView: View {
    let movieId: Int
    
    @StateObject private var viewModel: MovieDetailViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    init(movieId: Int) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if let movie = viewModel.movieDetail {
                    movieContentView(movie: movie)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavorite()
                }) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .blue)
                        .scaleEffect(viewModel.isFavorite ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: viewModel.isFavorite)
                }
            }
        }
        .onAppear {
            viewModel.setFavoritesManager(favoritesManager)
            if viewModel.movieDetail == nil {
                viewModel.loadMovieDetails()
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView("Loading...")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 400)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button("Retry") {
                viewModel.loadMovieDetails()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .padding(.top, 100)
    }
    
    private func movieContentView(movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            if let firstTrailer = viewModel.trailers.first {
                VideoPlayerView(videoKey: firstTrailer.key)
                    .aspectRatio(16/9, contentMode: .fit)
                    .padding(.horizontal, 10)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(movie.ratingText)
                            .fontWeight(.semibold)
                    }
                    
                    if movie.runtime != nil {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text(movie.durationText)
                        }
                    }
                    
                    Text(movie.yearText)
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
                
                if !movie.genres.isEmpty {
                    Text(movie.genresText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Overview")
                    .font(.headline)
                Text(movie.overview)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 10)
            
            if !viewModel.cast.isEmpty {
                castSection
                    .padding(.leading, 20)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeOut(duration: 0.5), value: movie.id)
    }
    
    private var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cast")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(viewModel.cast) { actor in
                        actorCard(actor: actor)
                    }
                }
            }
        }
    }
    
    private func actorCard(actor: Cast) -> some View {
        VStack(spacing: 2) {
            AsyncImage(url: actor.profileURL) { phase in
                switch phase {
                case .empty:
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                case .failure:
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            
            Text(actor.name)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80, alignment: .top)
                .fixedSize(horizontal: false, vertical: true)
            
            if let character = actor.character {
                Text(character)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 80, alignment: .top)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    NavigationStack {
        
        MovieDetailView(movieId: 1419406)
            .environmentObject(FavoritesManager(viewContext: PersistenceController.preview.container.viewContext))
        
    }
}
