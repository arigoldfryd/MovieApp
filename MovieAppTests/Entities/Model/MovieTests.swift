//
//  MovieTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class MovieTests: XCTestCase {
    func testMovieEquatable() {
        let movie1 = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "2023-01-01")
        let movie2 = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "2023-01-01")
        let movie3 = Movie(id: 2, title: "Movie B", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "2023-01-01")
        
        XCTAssertTrue(movie1 == movie2)
        XCTAssertFalse(movie1 == movie3)
    }
    
    func testMovieHashable() {
        let movie1 = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "2023-01-01")
        let movie2 = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "2023-01-01")
        
        XCTAssertEqual(movie1.hashValue, movie2.hashValue)
    }
    
    func testMovieCodable() throws {
        let movie = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "2023-01-01")
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(movie)
        
        let decoder = JSONDecoder()
        let decodedMovie = try decoder.decode(Movie.self, from: data)
        
        XCTAssertEqual(movie, decodedMovie)
    }
    
}
