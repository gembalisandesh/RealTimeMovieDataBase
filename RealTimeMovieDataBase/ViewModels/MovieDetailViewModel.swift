//
//  MovieDetailViewModel.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var trailers: [Video] = []
    @Published var cast: [Cast] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavorite = false
    
    private let apiService = APIService.shared
    private let networkMonitor = NetworkMonitor.shared
    private var favoritesManager: FavoritesManager?
    private var movieId: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(movieId: Int) {
        self.movieId = movieId
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.$isConnected
            .dropFirst()
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                if isConnected {
                    if self.movieDetail == nil && self.errorMessage != nil {
                        self.loadMovieDetails()
                    }
                } else {
                    self.errorMessage = "No internet connection. Please check your network settings."
                }
            }
            .store(in: &cancellables)
    }
    
    func setFavoritesManager(_ manager: FavoritesManager) {
        self.favoritesManager = manager
        updateFavoriteStatus()
    }
    
    func loadMovieDetails() {
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Please check your network settings."
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            async let detailsTask = apiService.fetchMovieDetails(id: movieId)
            async let videosTask = apiService.fetchMovieVideos(id: movieId)
            async let creditsTask = apiService.fetchMovieCredits(id: movieId)
            
            do {
                let (details, videos, credits) = try await (detailsTask, videosTask, creditsTask)
                
                self.movieDetail = details
                self.trailers = videos.results.filter { $0.isTrailer && $0.site.lowercased() == "youtube" }
                self.cast = Array(credits.cast.prefix(10))
                self.isLoading = false
                
                updateFavoriteStatus()
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func updateFavoriteStatus() {
        guard let favoritesManager = favoritesManager else { return }
        isFavorite = favoritesManager.isFavorite(movieId: movieId)
    }
    
    func toggleFavorite() {
        guard let favoritesManager = favoritesManager,
              let movieDetail = movieDetail else { return }
        
        favoritesManager.toggleFavorite(movieDetail: movieDetail)
        updateFavoriteStatus()
    }
}
