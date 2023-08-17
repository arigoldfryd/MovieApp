//
//  StringExtensionTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class StringExtensionTests: XCTestCase {
    
    func testConvertToDateWithValidFormat() {
        // Given
        let dateString = "2023-01-01"
        
        // When
        let convertedDate = dateString.convertToDate()
        
        // Then
        XCTAssertNotNil(convertedDate, "Conversion to Date should succeed for a valid date string.")
    }
    
    func testConvertToDateWithInvalidFormat() {
        // Given
        let dateString = "30/30/2030"
        
        // When
        let convertedDate = dateString.convertToDate()
        
        // Then
        XCTAssertNil(convertedDate, "Conversion to Date should fail for an invalid date string.")
    }
    
    func testConvertToDateWithEmptyString() {
        // Given
        let dateString = ""
        
        // When
        let convertedDate = dateString.convertToDate()
        
        // Then
        XCTAssertNil(convertedDate, "Conversion to Date should fail for an empty string.")
    }
    
}
