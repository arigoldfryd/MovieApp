//
//  SubscribedMovies.swift
//  MovieApp
//
//  Created by Ariel on 03/08/2023.
//

import Foundation

class SubscribedMovies: ObservableObject {

    @Published var movies: [Movie] = []
    private let localClient: LocalClient
    private let saveKey = "Movies"

    init(localClient: LocalClient = DefaultLocalClient()) {
        self.localClient = localClient
        load()
    }

    func contains(_ movie: Movie) -> Bool {
        movies.contains(movie)
    }

    func add(_ movie: Movie) {
        objectWillChange.send()
        movies.insert(movie, at: 0)
        save()
    }

    func remove(_ movie: Movie) {
        objectWillChange.send()
        movies.removeAll { $0.id == movie.id }
        save()
    }
    
    private func load() {
        guard let movies: [Movie] = try? localClient.get(forKey: saveKey) else {
            movies = []
            return
        }
        
        self.movies = movies
    }

    private func save() {
        try? localClient.set(value: movies, forKey: saveKey)
    }
}
