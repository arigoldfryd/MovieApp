//
//  MockSearchService.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import Foundation
@testable import MovieApp

class MockSearchService: SearchService {
    var fail = false
    
    @Published var searchMoviesCounter = 0
    @Published var searchMoviesText: String?
    
    func searchMovies(by text: String) async throws -> MovieResponse {
        searchMoviesCounter += 1
        searchMoviesText = text
        
        if fail {
            throw NSError(domain: "SearchServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Throwing a test error"])
        }
        
        let movie = MovieDTO(id: 99, title: "MovieA", genreIds: [1, 2], posterPath: "/poster", backdropPath: "/backdrop", overview: "OverviewTest", releaseDate: "2023-01-01")
        return MovieResponse(page: 1, results: [movie], totalPages: 1, totalResults: 1)
    }
}
