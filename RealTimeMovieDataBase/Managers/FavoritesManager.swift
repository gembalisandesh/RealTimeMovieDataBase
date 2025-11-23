//
//  FavoritesManager.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation
import CoreData
import Combine

class FavoritesManager: ObservableObject {
    @Published private(set) var favoriteIds: Set<Int> = []
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        loadFavorites()
    }
    
    private func loadFavorites() {
        let request = FavoriteMovie.fetchRequest()
        
        do {
            let favorites = try viewContext.fetch(request)
            favoriteIds = Set(favorites.map { Int($0.movieId) })
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    func isFavorite(movieId: Int) -> Bool {
        favoriteIds.contains(movieId)
    }
    
    func addFavorite(movie: Movie) {
        guard !favoriteIds.contains(movie.id) else { return }
        
        let favorite = FavoriteMovie(context: viewContext)
        favorite.movieId = Int32(movie.id)
        favorite.title = movie.title
        favorite.posterPath = movie.posterPath
        favorite.rating = movie.voteAverage
        favorite.addedDate = Date()
        
        do {
            try viewContext.save()
            favoriteIds.insert(movie.id)
        } catch {
            print("Error adding favorite: \(error)")
        }
    }
    
    func addFavorite(movieDetail: MovieDetail) {
        guard !favoriteIds.contains(movieDetail.id) else { return }
        
        let favorite = FavoriteMovie(context: viewContext)
        favorite.movieId = Int32(movieDetail.id)
        favorite.title = movieDetail.title
        favorite.posterPath = movieDetail.posterPath
        favorite.rating = movieDetail.voteAverage
        favorite.addedDate = Date()
        
        do {
            try viewContext.save()
            favoriteIds.insert(movieDetail.id)
        } catch {
            print("Error adding favorite: \(error)")
        }
    }
    
    func removeFavorite(movieId: Int) {
        let request = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "movieId == %d", movieId)
        
        do {
            let favorites = try viewContext.fetch(request)
            if let favorite = favorites.first {
                viewContext.delete(favorite)
                try viewContext.save()
                favoriteIds.remove(movieId)
            }
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    func removeFavorites(movieIds: Set<Int>) {
        let request = FavoriteMovie.fetchRequest()
        request.predicate = NSPredicate(format: "movieId IN %@", movieIds)
        
        do {
            let favorites = try viewContext.fetch(request)
            for favorite in favorites {
                viewContext.delete(favorite)
                favoriteIds.remove(Int(favorite.movieId))
            }
            try viewContext.save()
        } catch {
            print("Error removing favorites: \(error)")
        }
    }
    
    func toggleFavorite(movie: Movie) {
        if isFavorite(movieId: movie.id) {
            removeFavorite(movieId: movie.id)
        } else {
            addFavorite(movie: movie)
        }
    }
    
    func toggleFavorite(movieDetail: MovieDetail) {
        if isFavorite(movieId: movieDetail.id) {
            removeFavorite(movieId: movieDetail.id)
        } else {
            addFavorite(movieDetail: movieDetail)
        }
    }
    
    func getAllFavorites() -> [FavoriteMovie] {
        let request = FavoriteMovie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \FavoriteMovie.addedDate, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
}
