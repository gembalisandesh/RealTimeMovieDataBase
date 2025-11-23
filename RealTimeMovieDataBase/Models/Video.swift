//
//  Video.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import Foundation

struct VideosResponse: Codable {
    let id: Int
    let results: [Video]
}

struct Video: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool?
    let publishedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, key, name, site, type, official
        case publishedAt = "published_at"
    }
    
    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var isTrailer: Bool {
        type.lowercased() == "trailer"
    }
}
