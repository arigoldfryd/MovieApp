//
//  DiscoveryServiceTests.swift
//  MovieAppTests
//
//  Created by Ariel on 03/08/2023.
//

import XCTest
@testable import MovieApp

final class DiscoveryServiceTests: XCTestCase {
    var mockHttpClient: MockHTTPClient!
    var discoveryService: DiscoveryService!
    
    override func setUpWithError() throws {
        mockHttpClient = MockHTTPClient()
        discoveryService = DefaultMovieService(httpClient: mockHttpClient)
    }
    
    override func tearDownWithError() throws {
        mockHttpClient = nil
        discoveryService = nil
    }
    
    func testGetGenresFetchesFromNetwork() async throws {
        // Given
        let mockResponse = MovieResponse(page: 1, results: [MovieDTO(id: 0, title: "Test", genreIds: [1,2,3], posterPath: nil, backdropPath: nil, overview: "Overview", releaseDate: "2023-01-01")], totalPages: 2, totalResults: 10)
        mockHttpClient.responseData = try JSONEncoder().encode(mockResponse)
        
        // When
        let response = try await discoveryService.getMovies(page: 1)
        
        // Then
        XCTAssertEqual(response.results, mockResponse.results)
        XCTAssertEqual(response.totalPages, mockResponse.totalPages)
        XCTAssertEqual(response.totalResults, mockResponse.totalResults)
        XCTAssertEqual(response.page, mockResponse.page)
    }
    
    func testGetGenresThrowsErrorWhenHTTPClientThrowsError() async throws {
        // Given
        let expectedError = URLError(.notConnectedToInternet)
        mockHttpClient.responseError = expectedError
        
        // When & Then
        do {
            _ = try await discoveryService.getMovies(page: 1)
            XCTFail("Expected an error to be thrown.")
        } catch {
            XCTAssertEqual(error as? URLError, expectedError)
        }
    }

}
