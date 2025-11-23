//
//  FavoritesView.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteMovie.title, ascending: true)],
        animation: .default)
    private var favorites: FetchedResults<FavoriteMovie>
    
    var body: some View {
        NavigationStack {
            ZStack {
                if favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Browse movies and tap the heart icon to add favorites")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(favorites, id: \.movieId) { favorite in
                            NavigationLink(destination: MovieDetailView(movieId: Int(favorite.movieId))) {
                                FavoriteMovieRow(favorite: favorite)
                            }
                        }
                        .onDelete(perform: deleteFavorites)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
        }
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let favorite = favorites[index]
            favoritesManager.removeFavorite(movieId: Int(favorite.movieId))
        }
    }
}

#Preview {
    FavoritesView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(FavoritesManager(viewContext: PersistenceController.preview.container.viewContext))
}
