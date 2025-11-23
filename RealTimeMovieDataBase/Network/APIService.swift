//
//  APIService.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let message):
            return message
        }
    }
}

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    private func fetch<T: Decodable>(endpoint: String, queryItems: [URLQueryItem] = []) async throws -> T {
        guard var urlComponents = URLComponents(string: APIConstants.baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        var items = queryItems
        items.append(URLQueryItem(name: "api_key", value: APIConstants.apiKey))
        urlComponents.queryItems = items
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError("Server returned status code \(httpResponse.statusCode)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw APIError.decodingError
        }
    }
    
    func fetchPopularMovies(page: Int = 1) async throws -> MoviesResponse {
        let queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        return try await fetch(endpoint: APIConstants.Endpoints.popularMovies, queryItems: queryItems)
    }
    
    func searchMovies(query: String, page: Int = 1) async throws -> MoviesResponse {
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        return try await fetch(endpoint: APIConstants.Endpoints.searchMovies, queryItems: queryItems)
    }
    
    func fetchMovieDetails(id: Int) async throws -> MovieDetail {
        let endpoint = "\(APIConstants.Endpoints.movieDetails)/\(id)"
        return try await fetch(endpoint: endpoint)
    }
    
    func fetchMovieVideos(id: Int) async throws -> VideosResponse {
        let endpoint = "\(APIConstants.Endpoints.movieVideos)/\(id)/videos"
        return try await fetch(endpoint: endpoint)
    }
    
    func fetchMovieCredits(id: Int) async throws -> CreditsResponse {
        let endpoint = "\(APIConstants.Endpoints.movieCredits)/\(id)/credits"
        return try await fetch(endpoint: endpoint)
    }
}
