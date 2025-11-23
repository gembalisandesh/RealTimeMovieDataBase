//
//  MoviesViewModel.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation
import Combine

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var searchQuery = "" {
        didSet {
            if searchQuery.isEmpty {
                resetAndLoadPopularMovies()
            } else {
                resetAndSearchMovies()
            }
        }
    }
    
    private let apiService = APIService.shared
    private let networkMonitor = NetworkMonitor.shared
    private var searchTask: Task<Void, Never>?
    private var currentPage = 1
    private var totalPages = 1
    private var canLoadMore: Bool {
        currentPage < totalPages && !isLoading && !isLoadingMore
    }
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNetworkMonitoring()
        loadPopularMovies()
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.$isConnected
            .dropFirst()
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                if isConnected {
                    if self.movies.isEmpty && self.errorMessage != nil {
                        self.loadPopularMovies()
                    }
                } else {
                    self.errorMessage = "No internet connection. Please check your network settings."
                }
            }
            .store(in: &cancellables)
    }
    
    private func removeDuplicates(from newMovies: [Movie]) -> [Movie] {
        let existingIDs = Set(movies.map { $0.id })
        return newMovies.filter { !existingIDs.contains($0.id) }
    }
    
    func loadPopularMovies() {
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Please check your network settings."
            isLoading = false
            return
        }
        searchTask?.cancel()
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await apiService.fetchPopularMovies(page: 1)
                self.movies = response.results
                self.currentPage = response.page
                self.totalPages = response.totalPages
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func resetAndLoadPopularMovies() {
        currentPage = 1
        totalPages = 1
        movies = []
        loadPopularMovies()
    }
    
    func loadMoreMovies() {
        guard canLoadMore else { return }
        
        guard networkMonitor.isConnected else {
            return
        }
        
        isLoadingMore = true
        let nextPage = currentPage + 1
        
        Task {
            do {
                if searchQuery.isEmpty {
                    let response = try await apiService.fetchPopularMovies(page: nextPage)
                    let uniqueMovies = removeDuplicates(from: response.results)
                    self.movies.append(contentsOf: uniqueMovies)
                    self.currentPage = response.page
                    self.totalPages = response.totalPages
                } else {
                    let response = try await apiService.searchMovies(query: searchQuery, page: nextPage)
                    let uniqueMovies = removeDuplicates(from: response.results)
                    self.movies.append(contentsOf: uniqueMovies)
                    self.currentPage = response.page
                    self.totalPages = response.totalPages
                }
                self.isLoadingMore = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoadingMore = false
            }
        }
    }
    
    func searchMovies() {
        searchTask?.cancel()
        
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            resetAndLoadPopularMovies()
            return
        }
        
        guard networkMonitor.isConnected else {
            errorMessage = "No internet connection. Please check your network settings."
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        searchTask = Task(priority: .userInitiated) {
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                
                guard !Task.isCancelled else { return }
                
                let response = try await apiService.searchMovies(query: searchQuery, page: 1)
                
                guard !Task.isCancelled else { return }
                
                self.movies = response.results
                self.currentPage = response.page
                self.totalPages = response.totalPages
                self.isLoading = false
            } catch {
                guard !Task.isCancelled else { return }
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func resetAndSearchMovies() {
        currentPage = 1
        totalPages = 1
        movies = []
        searchMovies()
    }
    
    func refresh() {
        if searchQuery.isEmpty {
            resetAndLoadPopularMovies()
        } else {
            resetAndSearchMovies()
        }
    }
    
    func shouldLoadMore(currentItem: Movie) -> Bool {
        guard let lastMovie = movies.last else { return false }
        return currentItem.id == lastMovie.id && canLoadMore
    }
}
