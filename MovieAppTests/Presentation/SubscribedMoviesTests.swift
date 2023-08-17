//
//  SubscribedMoviesTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class SubscribedMoviesTests: XCTestCase {
    func testAddMovie() {
        // Given
        let mockClient = MockLocalClient()
        let viewModel = SubscribedMovies(localClient: mockClient)
        let movie = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "")
        
        // When
        viewModel.add(movie)
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertTrue(viewModel.contains(movie))
    }
    
    func testRemoveMovie() {
        // Given
        let mockClient = MockLocalClient()
        let viewModel = SubscribedMovies(localClient: mockClient)
        let movie = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "")
        
        // When
        viewModel.add(movie)
        viewModel.remove(movie)
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 0)
        XCTAssertFalse(viewModel.contains(movie))
    }
    
    func testLoadMoviesFromLocalStorage() {
        // Given
        let mockClient = MockLocalClient()
        let movie = Movie(id: 1, title: "Movie A", genres: [], posterPath: nil, backdropPath: nil, overview: "", releaseDate: "")
        mockClient.storedData["Movies"] = [movie]
        
        // When
        let viewModel = SubscribedMovies(localClient: mockClient)
        
        // Then
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertTrue(viewModel.contains(movie))
    }
    
    func testLoadMoviesFromEmptyLocalStorage() {
        // Given
        let mockClient = MockLocalClient()
        let viewModel = SubscribedMovies(localClient: mockClient)
        
        // When & Then
        XCTAssertEqual(viewModel.movies.count, 0)
    }
    
}
