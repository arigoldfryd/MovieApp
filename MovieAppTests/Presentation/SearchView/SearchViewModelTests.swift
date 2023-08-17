//
//  SearchViewModelTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import Combine
import XCTest
@testable import MovieApp

final class SearchViewModelTests: XCTestCase {
    
    private var cancellable = Set<AnyCancellable>()
    
    @MainActor func testSearchMoviesSuccess() {
        // Given
        let searchService = MockSearchService()
        let genreService = MockGenreService()
        
        let viewModel = SearchViewModel(
            genreService: genreService,
            searchService: searchService
        )
        
        // When
        let searchExpectation = XCTestExpectation()
        searchService.$searchMoviesCounter
            .sink { counter in
                if counter == 1 {
                    searchExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        
        let genresExpectation = XCTestExpectation()
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 1 {
                    genresExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        let viewModelExpectation = XCTestExpectation()
        viewModel.$movies
            .sink { movies in
                if let movies = movies, !movies.isEmpty {
                    viewModelExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        Task {
            await viewModel.searchMovies(by: "Movie")
        }
        
        // Then
        wait(for: [searchExpectation, genresExpectation, viewModelExpectation], timeout: 1.0)
        
        XCTAssertNotNil(viewModel.movies)
        XCTAssertEqual(viewModel.movies?.count, 1)
        XCTAssertEqual(viewModel.movies?.first?.id, 99)
        XCTAssertEqual(viewModel.movies?.first?.title, "MovieA")
        XCTAssertEqual(viewModel.movies?.first?.genres.count, 2)
        XCTAssertEqual(viewModel.movies?.first?.overview, "OverviewTest")
        XCTAssertEqual(viewModel.movies?.first?.releaseDate, "2023")
        XCTAssertEqual(viewModel.movies?.first?.posterPath?.absoluteString, "https://image.tmdb.org/t/p/w780/poster")
        XCTAssertEqual(viewModel.movies?.first?.backdropPath?.absoluteString, "https://image.tmdb.org/t/p/original/backdrop")
    }
    
    @MainActor func testSearchMoviesWithASearchServiceError() {
        // Given
        let searchService = MockSearchService()
        searchService.fail = true
        let genreService = MockGenreService()
        
        let viewModel = SearchViewModel(
            genreService: genreService,
            searchService: searchService
        )
        
        // When
        let searchExpectation = XCTestExpectation(description: "Search")
        searchService.$searchMoviesCounter
            .sink { counter in
                if counter == 1 {
                    searchExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        let genresExpectation = XCTestExpectation(description: "Genres")
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 0 {
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
            await viewModel.searchMovies(by: "Movie")
        }
        
        // Then
        wait(for: [searchExpectation, genresExpectation, viewModelExpectation], timeout: 1.0)
        
        XCTAssertEqual(genreService.getGenresCounter, 1)
        XCTAssertEqual(searchService.searchMoviesCounter, 1)
        
        XCTAssertNil(viewModel.movies)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual((viewModel.error as? NSError)?.domain, "SearchServiceError")
        XCTAssertEqual(viewModel.error?.localizedDescription, "Throwing a test error")
    }
    
    @MainActor func testSearchMoviesWithAGenreServiceError() {
        // Given
        let searchService = MockSearchService()
        let genreService = MockGenreService()
        genreService.fail = true
        
        let viewModel = SearchViewModel(
            genreService: genreService,
            searchService: searchService
        )
        
        // When
        let searchExpectation = XCTestExpectation(description: "Search")
        searchService.$searchMoviesCounter
            .sink { counter in
                if counter == 1 {
                    searchExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        let genresExpectation = XCTestExpectation(description: "Genres")
        genreService.$getGenresCounter
            .sink { counter in
                if counter == 0 {
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
            await viewModel.searchMovies(by: "Movie")
        }
        
        // Then
        wait(for: [searchExpectation, genresExpectation, viewModelExpectation], timeout: 1.0)
        
        XCTAssertEqual(genreService.getGenresCounter, 1)
        XCTAssertEqual(searchService.searchMoviesCounter, 1)
        
        XCTAssertNil(viewModel.movies)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual((viewModel.error as? NSError)?.domain, "GenreServiceError")
        XCTAssertEqual(viewModel.error?.localizedDescription, "Throwing a test error")
    }
    
    @MainActor func testCleanResults() {
        // Given
        let searchService = MockSearchService()
        let genreService = MockGenreService()
        
        let viewModel = SearchViewModel(
            genreService: genreService,
            searchService: searchService
        )
        
        // When
        let viewModelExpectation = XCTestExpectation()
        viewModel.$movies
            .sink { movies in
                if movies == nil {
                    viewModelExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        Task {
            await viewModel.searchMovies(by: "Action")
            viewModel.cleanResults()
        }
        
        // Then
        wait(for: [viewModelExpectation], timeout: 1.0)
        
        XCTAssertNil(viewModel.movies)
    }
    
}
