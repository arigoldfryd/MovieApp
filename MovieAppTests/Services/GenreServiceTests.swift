//
//  GenreServiceTests.swift
//  MovieAppTests
//
//  Created by Ariel on 03/08/2023.
//

@testable import MovieApp
import XCTest

final class GenreServiceTests: XCTestCase {
    var mockHttpClient: MockHTTPClient!
    var genreService: DefaultGenreService!
    
    override func setUpWithError() throws {
        mockHttpClient = MockHTTPClient()
        genreService = DefaultGenreService(httpClient: mockHttpClient)
    }
    
    override func tearDownWithError() throws {
        mockHttpClient = nil
        genreService = nil
    }
    
    func testGetGenresFetchesFromNetwork() async throws {
        // Given
        let mockResponse = GenreResponse(genres: [Genre(id: 1, name: "Action"),
                                                  Genre(id: 2, name: "Comedy"),
                                                  Genre(id: 3, name: "Drama")])
        mockHttpClient.responseData = try JSONEncoder().encode(mockResponse)
        
        // When
        let response = try await genreService.getGenres()
        
        // Then
        XCTAssertEqual(response.genres, mockResponse.genres)
    }
    
    func testGetGenresThrowsErrorWhenHTTPClientThrowsError() async throws {
        // Given
        let expectedError = URLError(.notConnectedToInternet)
        mockHttpClient.responseError = expectedError
        
        // When & Then
        do {
            _ = try await genreService.getGenres()
            XCTFail("Expected an error to be thrown.")
        } catch {
            XCTAssertEqual(error as? URLError, expectedError)
        }
    }
}
