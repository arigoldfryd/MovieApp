//
//  UIColorExtensionTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class UIColorExtensionTests: XCTestCase {
    
    func testInitWithValidHex() {
        // Given
        let hexString = "FF5733"
        let alpha: CGFloat = 0.7
        
        // When & Then
        if let color = UIColor(hex: hexString, alpha: alpha) {
            XCTAssertNotNil(color.cgColor)
            XCTAssertEqual(color.cgColor.alpha, alpha)
        } else {
            XCTFail("Color creation should not fail with a valid hex string.")
        }
    }
    
    func testInitWithInvalidHex() {
        // Given
        let invalidHexString = "F5733"
        let validHexString = "FF5733"
        
        // When
        let invalidColor = UIColor(hex: invalidHexString)
        let validColor = UIColor(hex: validHexString)
        
        // Then
        XCTAssertNil(invalidColor)
        XCTAssertNotNil(validColor)
    }
    
    func testGetHigherContrastForBlack() {
        // Given
        let black = UIColor.black
        
        // When
        let higherContrastColor = black.getHigherContrast()
        
        // Then
        XCTAssertEqual(higherContrastColor, UIColor.white)
    }
    
    func testGetHigherContrastForWhite() {
        // Given
        let white = UIColor.white
        
        // When
        let higherContrastColor = white.getHigherContrast()
        
        // Then
        XCTAssertEqual(higherContrastColor, UIColor.black)
    }
}
