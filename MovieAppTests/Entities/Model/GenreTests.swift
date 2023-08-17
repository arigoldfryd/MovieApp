//
//  GenreTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class GenreTests: XCTestCase {
    func testGenreEquatable() {
        let genre1 = Genre(id: 1, name: "Action")
        let genre2 = Genre(id: 1, name: "Action")
        let genre3 = Genre(id: 2, name: "Drama")
        
        XCTAssertTrue(genre1 == genre2)
        XCTAssertFalse(genre1 == genre3)
    }
    
    func testGenreHashable() {
        let genre1 = Genre(id: 1, name: "Action")
        let genre2 = Genre(id: 1, name: "Action")
        
        XCTAssertEqual(genre1.hashValue, genre2.hashValue)
    }
    
    func testGenreCodable() throws {
        let genre = Genre(id: 1, name: "Action")
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(genre)
        
        let decoder = JSONDecoder()
        let decodedGenre = try decoder.decode(Genre.self, from: data)
        
        XCTAssertEqual(genre, decodedGenre)
    }
    
}
