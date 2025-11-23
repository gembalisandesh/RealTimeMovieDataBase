//
//  MovieDetail.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation

struct MovieDetail: Codable, Identifiable {
    let id: Int
    let title: String
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, tagline, status
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
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
    
    var durationText: String {
        guard let runtime = runtime, runtime > 0 else {
            return "N/A"
        }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    var genresText: String {
        genres.map { $0.name }.joined(separator: ", ")
    }
}

struct CreditsResponse: Codable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, character, order
        case profilePath = "profile_path"
    }
    
    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "\(APIConstants.imageBaseURL)/w185\(profilePath)")
    }
}
