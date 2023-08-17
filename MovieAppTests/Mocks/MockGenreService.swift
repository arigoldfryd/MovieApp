//
//  MockGenreService.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import Foundation
@testable import MovieApp

class MockGenreService: GenreService {
    @Published var getGenresCounter = 0
    
    var fail = false
    var genresResponse: GenreResponse = GenreResponse(genres: [
        Genre(id: 1, name: "GenreA"),
        Genre(id: 2, name: "GenreB"),
        Genre(id: 3, name: "GenreC"),
    ])
    
    func getGenres() async throws -> GenreResponse {
        getGenresCounter += 1
        
        if fail {
            throw NSError(domain: "GenreServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Throwing a test error"])
        }
        
        return genresResponse
    }
}
