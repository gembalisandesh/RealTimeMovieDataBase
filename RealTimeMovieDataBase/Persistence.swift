//
//  Persistence.swift
//  RealTimeMovieDataBase
//
//  Created by Sandesh on 22/11/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let sampleMovies = [
            ("The Shadow's Edge", 1419406, "/e0RU6KpdnrqFxDKlI3NOqN8nHL6.jpg", 6.5),
            ("Frankenstein", 1062722, "/g4JtvGlQO7DByTI6frUobqvSL3R.jpg", 7.789),
            ("Aquaman", 297802, "/ufl63EFcc5XpByEV2Ecdw6WJZAI.jpg", 6.872)
        ]
        
        for (title, id, posterPath, rating) in sampleMovies {
            let favorite = FavoriteMovie(context: viewContext)
            favorite.title = title
            favorite.movieId = Int32(id)
            favorite.posterPath = posterPath
            favorite.rating = rating
            favorite.addedDate = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RealTimeMovieDataBase")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
