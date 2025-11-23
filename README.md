# 🎬 RealTimeMovieDataBase

A modern, feature-rich iOS movie browsing application built with SwiftUI that integrates with The Movie Database (TMDb) API. Browse popular movies, search for your favorites, watch trailers, and manage your personal collection with an elegant, cinematic user interface.

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green)

## ✨ Features

### 🎥 Movie Browsing & Discovery
- **Popular Movies Grid**: Browse trending movies in a beautiful, responsive grid layout
- **Real-time Search**: Search for any movie with intelligent debouncing for optimal performance
- **Floating Search Bar**: Always-visible glassmorphic search bar that stays on top while scrolling.
- **Dark Mode Support**: Adaptive UI that automatically adjusts colors for light and dark system themes.
- **Movie Details**: Comprehensive movie information including:
  - High-quality posters and backdrops
  - Plot overview and synopsis
  - Release date and runtime
  - IMDb ratings and vote counts
  - Genre tags
  - Cast information with photos

### 📺 Video Integration
- **Embedded Trailers**: Watch movie trailers directly within the app using YouTube integration
- **Smooth Video Playback**: Optimized video player with 16:9 aspect ratio

### ❤️ Favorites Management
- **Persistent Favorites**: Save your favorite movies with Core Data persistence
- **Quick Access**: Dedicated favorites tab for easy access to your collection
- **Swipe to Delete**: Remove favorites with intuitive swipe gestures
- **Multi-Selection**: Select and delete multiple favorites at once
- **Instant Sync**: Real-time synchronization across all views

### 🎨 Modern UI/UX
- **Cinematic Design**: Sleek, modern interface optimized for movie browsing
- **Smooth Animations**: Polished transitions and micro-interactions
- **Responsive Layout**: Adaptive design that works beautifully on all iPhone sizes
- **Image Caching**: Advanced URLCache implementation for smooth scrolling and optimal performance
- **Loading States**: Elegant loading indicators and error handling
- **Pull-to-Refresh**: Refresh movie data with a simple pull gesture

### 🔧 Technical Features
- **SwiftUI Architecture**: Built entirely with modern SwiftUI
- **MVVM Pattern**: Clean separation of concerns with ViewModels
- **Core Data Integration**: Robust local data persistence
- **Async/Await**: Modern Swift concurrency for network calls
- **Error Handling**: Comprehensive error states with retry functionality
- **Performance Optimized**: 
  - Image caching (100MB memory, 200MB disk)
  - Duplicate ID handling
  - Efficient list rendering

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- TMDb API Key (free)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/gembalisandesh/RealTimeMovieDataBase.git
cd RealTimeMovieDataBase
```

2. **Get your TMDb API Key**
   - Visit [The Movie Database API Settings](https://www.themoviedb.org/settings/api)
   - Sign up or log in to your account
   - Request an API key (it's completely free!)
   - Copy your API key

3. **Configure the API Key**
   - Open the project in Xcode:
     ```bash
     open RealTimeMovieDataBase.xcodeproj
     ```
   - Navigate to `RealTimeMovieDataBase/Network/APIConstants.swift`
   - Replace `YOUR_API_KEY_HERE` with your actual API key:
     ```swift
     static let apiKey = "your_actual_api_key_here"
     ```

4. **Build and Run**
   - Select your target device or simulator (iPhone 15 Pro recommended)
   - Press `Cmd+R` or click the Run button
   - The app will launch with a splash screen animation

## 📱 App Structure

```
RealTimeMovieDataBase/
├── Models/
│   ├── Movie.swift              # Movie data model
│   ├── MovieDetail.swift        # Detailed movie information
│   └── Video.swift              # Trailer/video model
├── Views/
│   ├── ContentView.swift        # Main tab container
│   ├── MoviesListView.swift     # Movie grid/search view
│   ├── MovieCardView.swift      # Individual movie card
│   ├── MovieDetailView.swift    # Movie detail screen
│   ├── FavoritesView.swift      # Favorites collection
│   ├── FavoriteMovieRow.swift   # Favorite list item
│   ├── VideoPlayerView.swift    # YouTube player
│   └── SimpleLoadingView.swift  # Splash screen
├── ViewModels/
│   ├── MoviesViewModel.swift        # Movies list logic
│   └── MovieDetailViewModel.swift   # Movie detail logic
├── Network/
│   ├── APIConstants.swift       # API configuration
│   └── APIService.swift         # Network layer
├── Managers/
│   └── FavoritesManager.swift   # Core Data manager
├── Utilities/
│   └── ImageCache.swift         # Image caching utilities
└── Persistence.swift            # Core Data stack
```

## 🎯 Usage

### Browsing Movies
1. Launch the app to see popular movies
2. Scroll through the grid to explore
3. Pull down to refresh the movie list

### Searching
1. Tap the search bar at the top
2. Type your query (search activates after a brief pause)
3. Results update in real-time

### Viewing Details
1. Tap any movie card
2. Watch the trailer (if available)
3. Scroll to see cast, ratings, and overview
4. Tap the heart icon to add/remove from favorites

### Managing Favorites
1. Switch to the "Favorites" tab
2. View all your saved movies
3. Swipe left on any item to delete
4. Tap to view full details

## 🛠️ Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **Core Data**: Local data persistence
- **Combine**: Reactive programming for search debouncing
- **URLSession**: Network requests with async/await
- **WebKit**: YouTube video embedding
- **TMDb API**: Movie data and images

## 🎨 Design Highlights

- **Adaptive Grid Layout**: Responsive movie card grid
- **Smooth Animations**: Scale and fade transitions
- **Error States**: User-friendly error messages with retry
- **Empty States**: Helpful guidance when no content is available
- **Tab Navigation**: Clean bottom tab bar interface
- **Navigation Stack**: Seamless navigation between views

## 📝 API Reference

This app uses [The Movie Database (TMDb) API](https://www.themoviedb.org/documentation/api):
- Popular Movies endpoint
- Movie Search endpoint
- Movie Details endpoint
- Movie Credits (Cast) endpoint
- Movie Videos (Trailers) endpoint

## 🐛 Known Issues & Solutions

- **Blank Images**: Resolved with robust image caching and duplicate ID handling
- **Search Performance**: Optimized with debouncing mechanism
- **Tab Bar Visibility**: Properly managed across navigation stack

## 📄 License

This project is available for personal and educational use.

## 🙏 Acknowledgments

- Movie data provided by [The Movie Database (TMDb)](https://www.themoviedb.org/)
- Trailer videos from YouTube
- Built with ❤️ using SwiftUI

## 📧 Contact

For questions or feedback, please open an issue on GitHub.

---

**Note**: This app uses the TMDb API but is not endorsed or certified by TMDb.
