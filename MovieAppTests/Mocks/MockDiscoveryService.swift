//
//  MockDiscoveryService.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import Foundation
@testable import MovieApp

class MockDiscoveryService: DiscoveryService {    
    @Published var getMoviesCounter = 0
    
    var fail = false
    var moviesResponse: MovieResponse = MovieResponse(page: 1, results: [MovieDTO(id: 99, title: "MovieA", genreIds: [1,2,3], posterPath: "/poster", backdropPath: "/backdrop", overview: "OverviewTest", releaseDate: "2023-01-01")], totalPages: 2, totalResults: 1)
    
    func getMovies(page: Int) async throws -> MovieResponse {
        getMoviesCounter += 1
        
        if fail {
            throw NSError(domain: "DiscoveryServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Throwing a test error"])
        }
        
        return moviesResponse
    }
}
