//
//  SimpleLoadingView.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 23/11/25.
//

import SwiftUI

struct SimpleLoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "film.stack")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Real Time Movie DataBase")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                ProgressView()
                    .scaleEffect(1.2)
                    .padding(.top, 8)
                
                Text("Loading movies...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SimpleLoadingView()
}
