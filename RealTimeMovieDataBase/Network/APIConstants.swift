//
//  APIConstants.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation

struct APIConstants {
    static let apiKey = "c279633b65e09a63f08db11d6ff7e4f0"
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"
    
    static let posterSize = "w500"
    static let backdropSize = "w780"
    
    struct Endpoints {
        static let popularMovies = "/movie/popular"
        static let searchMovies = "/search/movie"
        static let movieDetails = "/movie"
        static let movieVideos = "/movie"
        static let movieCredits = "/movie"
    }
    
    static func posterURL(path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "\(imageBaseURL)/\(posterSize)\(path)")
    }
    
    static func backdropURL(path: String?) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "\(imageBaseURL)/\(backdropSize)\(path)")
    }
}
