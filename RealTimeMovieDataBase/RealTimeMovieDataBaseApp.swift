//
//  RealTimeMovieDataBaseApp.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import SwiftUI
import CoreData

@main
struct RealTimeMovieDataBaseApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        let memoryCapacity = 100 * 1024 * 1024
        let diskCapacity = 200 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        URLCache.shared = cache
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(FavoritesManager(viewContext: persistenceController.container.viewContext))
        }
    }
}
