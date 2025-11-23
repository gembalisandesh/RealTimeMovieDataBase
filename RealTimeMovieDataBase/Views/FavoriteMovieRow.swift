//
//  FavoriteMovieRow.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI

struct FavoriteMovieRow: View {
    let favorite: FavoriteMovie
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            ProgressView()
                        }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 120)
            .clipped()
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(favorite.title ?? "Unknown")
                    .font(.headline)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", favorite.rating))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let date = favorite.addedDate {
                    Text("Added \(date, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var posterURL: URL? {
        guard let path = favorite.posterPath else { return nil }
        return APIConstants.posterURL(path: path)
    }
}
