//
//  MovieMapperTests.swift
//  MovieAppTests
//
//  Created by Ariel on 03/08/2023.
//

import XCTest
@testable import MovieApp

final class MovieMapperTests: XCTestCase {
    
    var mapper: MovieMapper!
    
    override func setUpWithError() throws {
        mapper = DefaultMovieMapper()
    }
    
    override func tearDownWithError() throws {
        mapper = nil
    }
    
    func testMapEmptyDTOArray() {
        // Given
        let movieDTOs: [MovieDTO] = []
        let genres: [Genre] = []
        
        // When
        let movies = mapper.mapDTOToModel(movies: movieDTOs, genres: genres)
        
        // Then
        XCTAssertTrue(movies.isEmpty)
    }
    
    func testMapDTOWithGenres() {
        // Given
        let movieDTOs = [
            MovieDTO(id: 1, title: "Movie A", genreIds: [1, 2], posterPath: "/posterA.jpg", backdropPath: "/backdropA.jpg", overview: "Overview A", releaseDate: "2021-08-15"),
            MovieDTO(id: 2, title: "Movie B", genreIds: [3, 4], posterPath: "/posterB.jpg", backdropPath: "/backdropB.jpg", overview: "Overview B", releaseDate: "2022-02-28")
        ]
        
        let genres = [
            Genre(id: 1, name: "Genre1"),
            Genre(id: 2, name: "Genre2"),
            Genre(id: 3, name: "Genre3"),
            Genre(id: 4, name: "Genre4")
        ]
        
        // When
        let movies = mapper.mapDTOToModel(movies: movieDTOs, genres: genres)
        
        // Then
        XCTAssertEqual(movies.count, 2)
        XCTAssertEqual(movies[0].title, "Movie A")
        XCTAssertEqual(movies[1].title, "Movie B")
        XCTAssertEqual(movies[0].genres.map { $0.name }, ["Genre1", "Genre2"])
        XCTAssertEqual(movies[1].genres.map { $0.name }, ["Genre3", "Genre4"])
    }
    
    func testMapDTOWithInvalidReleaseDate() {
        // Given
        let movieDTO = MovieDTO(id: 1, title: "Movie", genreIds: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "Invalid Date Format")
        
        // When
        let movies = mapper.mapDTOToModel(movies: [movieDTO], genres: [])
        
        // Then
        XCTAssertEqual(movies[0].releaseDate, "")
    }
    
    func testMapDTOWithInvalidPaths() {
        // Given
        let movieDTO = MovieDTO(id: 1, title: "Movie", genreIds: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "")
        
        // When
        let movies = mapper.mapDTOToModel(movies: [movieDTO], genres: [])
        
        // Then
        XCTAssertNil(movies[0].posterPath)
        XCTAssertNil(movies[0].backdropPath)
    }
}
