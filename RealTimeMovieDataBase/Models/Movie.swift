//
//  Movie.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let adult: Bool
    let video: Bool
    let genreIds: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, popularity, adult, video
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
    }
    
    var posterURL: URL? {
        APIConstants.posterURL(path: posterPath)
    }
    
    var backdropURL: URL? {
        APIConstants.backdropURL(path: backdropPath)
    }
    
    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }
    
    var yearText: String {
        guard let releaseDate = releaseDate,
              let year = releaseDate.split(separator: "-").first else {
            return "N/A"
        }
        return String(year)
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}
