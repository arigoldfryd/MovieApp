//
//  MovieListViewModelTests.swift
//  MovieAppTests
//
//  Created by Ariel on 03/08/2023.
//

import XCTest
import Combine
@testable import MovieApp

final class MovieListViewModelTests: XCTestCase {
    
    private var cancellable = Set<AnyCancellable>()
    
    @MainActor func testGetMovies() {
        // Given
        let discoveryService = MockDiscoveryService()
        let genreService = MockGenreService()
        
        let viewModel = MovieListViewModel(
            discoveryService: discoveryService,
            genreService: genreService
        )
        
        // When
        let discoveryExpectation = XCTestExpectation(description: "Discovery")
        discoveryService.$getMoviesCounter
            .sink { counter in
                if counter == 1 {
                    discoveryExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        let genresExpectation = XCTestExpectation(description: "Genres")
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 1 {
                    genresExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        let viewModelExpectation = XCTestExpectation(description: "ViewModel")
        viewModel.$movies
            .sink { movies in
                if !movies.isEmpty {
                    viewModelExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        Task {
            await viewModel.getMovies()
        }
        
        // Then
        wait(for: [discoveryExpectation, genresExpectation, viewModelExpectation], timeout: 3.0)
        
        XCTAssertEqual(discoveryService.getMoviesCounter, 1)
        XCTAssertEqual(genreService.getGenresCounter, 1)
        
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.id, 99)
        XCTAssertEqual(viewModel.movies.first?.title, "MovieA")
        XCTAssertEqual(viewModel.movies.first?.genres.count, 3)
        XCTAssertEqual(viewModel.movies.first?.overview, "OverviewTest")
        XCTAssertEqual(viewModel.movies.first?.releaseDate, "2023")
        XCTAssertEqual(viewModel.movies.first?.posterPath?.absoluteString, "https://image.tmdb.org/t/p/w780/poster")
        XCTAssertEqual(viewModel.movies.first?.backdropPath?.absoluteString, "https://image.tmdb.org/t/p/original/backdrop")
    }

    @MainActor func testGetMoviesExceedingTotalPages() {
        // Given
        let discoveryService = MockDiscoveryService()
        let genreService = MockGenreService()
        
        let viewModel = MovieListViewModel(
            discoveryService: discoveryService,
            genreService: genreService
        )
        
        // When
        let discoveryExpectation = XCTestExpectation()
        discoveryService.$getMoviesCounter
            .sink { counter in
                if counter == 2 {
                    discoveryExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        let genresExpectation = XCTestExpectation()
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 2 {
                    genresExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        Task {
            await viewModel.getMovies()
            await viewModel.getMovies()
            await viewModel.getMovies()
            await viewModel.getMovies()
        }
                
        // Then
        wait(for: [discoveryExpectation, genresExpectation], timeout: 1.0)
        
        XCTAssertEqual(discoveryService.getMoviesCounter, 2)
        XCTAssertEqual(genreService.getGenresCounter, 2)
    }
    
    @MainActor func testGetMoviesWithADiscoveryServiceError() {
        // Given
        let discoveryService = MockDiscoveryService()
        discoveryService.fail = true
        let genreService = MockGenreService()

        let viewModel = MovieListViewModel(
            discoveryService: discoveryService,
            genreService: genreService
        )

        // When
        let discoveryExpectation = XCTestExpectation(description: "Discovery")
        discoveryService.$getMoviesCounter
            .sink { counter in
                if counter == 1 {
                    discoveryExpectation.fulfill()
                }
            }
            .store(in: &cancellable)

        let genresExpectation = XCTestExpectation(description: "Genres")
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 1 {
                    genresExpectation.fulfill()
                }
            }
            .store(in: &cancellable)

        let viewModelExpectation = XCTestExpectation(description: "ViewModel")
        viewModel.$error
            .sink { error in
                if error != nil {
                    viewModelExpectation.fulfill()
                }
            }
            .store(in: &cancellable)

        Task {
            await viewModel.getMovies()
        }

        // Then
        wait(for: [discoveryExpectation, genresExpectation, viewModelExpectation], timeout: 1.0)

        XCTAssertEqual(discoveryService.getMoviesCounter, 1)
        XCTAssertEqual(genreService.getGenresCounter, 1)
        XCTAssertEqual((viewModel.error as? NSError)?.domain, "DiscoveryServiceError")
        XCTAssertEqual(viewModel.error?.localizedDescription, "Throwing a test error")
    }
    
    @MainActor func testGetMoviesWithAGenreServiceError() {
        // Given
        let discoveryService = MockDiscoveryService()
        let genreService = MockGenreService()
        genreService.fail = true

        let viewModel = MovieListViewModel(
            discoveryService: discoveryService,
            genreService: genreService
        )

        // When
        let discoveryExpectation = XCTestExpectation(description: "Discovery")
        discoveryService.$getMoviesCounter
            .sink { counter in
                if counter == 1 {
                    discoveryExpectation.fulfill()
                }
            }
            .store(in: &cancellable)

        let genresExpectation = XCTestExpectation(description: "Genres")
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 1 {
                    genresExpectation.fulfill()
                }
            }
            .store(in: &cancellable)

        let viewModelExpectation = XCTestExpectation(description: "ViewModel")
        viewModel.$error
            .sink { error in
                if error != nil {
                    viewModelExpectation.fulfill()
                }
            }
            .store(in: &cancellable)

        Task {
            await viewModel.getMovies()
        }

        // Then
        wait(for: [discoveryExpectation, genresExpectation, viewModelExpectation], timeout: 1.0)

        XCTAssertEqual(discoveryService.getMoviesCounter, 1)
        XCTAssertEqual(genreService.getGenresCounter, 1)
        XCTAssertEqual((viewModel.error as? NSError)?.domain, "GenreServiceError")
        XCTAssertEqual(viewModel.error?.localizedDescription, "Throwing a test error")
    }
}
