//
//  VideoPlayerView.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoKey: String?
    
    var body: some View {
        Group {
            if let videoKey = videoKey {
                Link(destination: youtubeURL(for: videoKey)) {
                    ZStack {
                        AsyncImage(url: youtubeThumbnailURL(for: videoKey)) { phase in
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
                                        Image(systemName: "video")
                                            .foregroundColor(.gray)
                                            .font(.largeTitle)
                                    }
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.7))
                                .frame(width: 64, height: 64)
                            
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                                .font(.title)
                        }
                    }
                }
                .clipped()
                .cornerRadius(12)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    
                    VStack(spacing: 8) {
                        Image(systemName: "video.slash")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No trailer available")
                            .foregroundColor(.secondary)
                    }
                }
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(12)
            }
        }
    }
    
    private func youtubeURL(for key: String) -> URL {
        URL(string: "https://www.youtube.com/watch?v=\(key)")!
    }
    
    private func youtubeThumbnailURL(for key: String) -> URL {
        URL(string: "https://img.youtube.com/vi/\(key)/maxresdefault.jpg")!
    }
}

#Preview {
    VStack {
        VideoPlayerView(videoKey: "pFTqZScX3Yk")
            .padding()
        
        VideoPlayerView(videoKey: nil)
            .padding()
    }
}
