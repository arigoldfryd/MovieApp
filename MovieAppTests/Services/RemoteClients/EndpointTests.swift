//
//  EndpointTests.swift
//  MovieAppTests
//
//  Created by Ariel on 03/08/2023.
//

import XCTest
@testable import MovieApp

final class EndpointTests: XCTestCase {
    
    func testURLWithPathAndAPIKey() {
        // Given
        let endpoint = Endpoint(path: "movies/popular")
        
        // When
        let url = endpoint.url
        
        // Then
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movies/popular?api_key=TEST_API_KEY")
    }
    
    func testURLWithPathAPIKeyAndQueryItem() {
        // Given
        let endpoint = Endpoint(path: "movies/top_rated", queryItems: [
            URLQueryItem(name: "page", value: "1")
        ])
        
        // When
        let url = endpoint.url
        
        // Then
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movies/top_rated?api_key=TEST_API_KEY&page=1")
    }
    
    func testURLWithMultiplePathComponentsAndQueryItems() {
        // Given
        let endpoint = Endpoint(path: "movies/search/horror", queryItems: [
            URLQueryItem(name: "year", value: "2023"),
            URLQueryItem(name: "sort_by", value: "popularity")
        ])
        
        // When
        let url = endpoint.url
        
        // Then
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movies/search/horror?api_key=TEST_API_KEY&year=2023&sort_by=popularity")
    }
    
}
