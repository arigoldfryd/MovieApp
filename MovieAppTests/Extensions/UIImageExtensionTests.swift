//
//  UIImageExtensionTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class UIImageExtensionTests: XCTestCase {
    
    func testProminentColorWithValidImage() {
        // Given
        let image = UIImage(systemName: "wifi")!
        
        // When
        let prominentColor = image.prominentColor()
        
        // Then
        XCTAssertNotNil(prominentColor, "Prominent color should not be nil for a valid image.")
    }
    
    func testProminentColorWithInvalidImage() {
        // Given
        let invalidImage = UIImage()
        
        // When
        let prominentColor = invalidImage.prominentColor()
        
        // Then
        XCTAssertNil(prominentColor, "Prominent color should be nil for an invalid image.")
    }
    
    
}
