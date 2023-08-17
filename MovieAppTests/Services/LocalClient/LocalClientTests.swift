//
//  LocalClientTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class LocalClientTests: XCTestCase {
    private var storage: [String: Any?] = [:]
    
    func mockSetValue(value: Any?, key: String) {
        storage[key] = value
    }
    
    func mockGetValue(forKey key: String) -> Data? {
        guard let value = storage[key] as? Data else {
            return nil
        }
        
        return value
    }
    
    func testSetAndGetValue() throws {
        // Given
        let localClient = DefaultLocalClient(set: mockSetValue, get: mockGetValue)
        let value = "Test"
        let key = "test_key"
        
        // When
        try localClient.set(value: value, forKey: key)
        let retrievedData: String? = try localClient.get(forKey: key)
        
        // Then
        XCTAssertEqual(retrievedData, value)
    }
    
    func testGetNonExistentValue() throws {
        // Given
        let localClient = DefaultLocalClient(set: mockSetValue, get: mockGetValue)
        
        // When
        let retrievedData: String? = try localClient.get(forKey: "non_existent_key")
        
        // Then
        XCTAssertNil(retrievedData)
    }
    
    func testDecodingErrorInGet() throws {
        // Given
        let localClient = DefaultLocalClient(set: mockSetValue, get: mockGetValue)
        let validData = #"{"message": "Hello, world!"}"#.data(using: .utf8)!
        storage["invalid_key"] = validData
        
        // When
        do {
            // Attempt to get the data as an invalid type
            let _: Int? = try localClient.get(forKey: "invalid_key")
            XCTFail("Expected decoding error, but no error was thrown")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
    
}
