//
//  HTTPClientTests.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import XCTest
@testable import MovieApp

final class HTTPClientTests: XCTestCase {
    struct TestResponse: Codable {
        let message: String
    }
    
    let testData = #"{"message": "Hello, world!"}"#.data(using: .utf8)!
    
    func mockPerform(request: URLRequest) async throws -> (Data, URLResponse) {
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (testData, httpResponse)
    }
    
    func mockErrorPerform(request: URLRequest) async throws -> (Data, URLResponse) {
        throw URLError(.notConnectedToInternet)
    }
    
    func mockErrorDecode(request: URLRequest) async throws -> (Data, URLResponse) {
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (Data(), httpResponse)
    }
    
    func testPerformErrorInPerform() async throws {
        // Given
        let httpClient = DefaultHTTPClient(perform: mockErrorPerform)
        
        do {
            // When
            let _: TestResponse = try await httpClient.perform(request: URLRequest(url: URL(string: "http://example.com")!))
            XCTFail("Expected URLError.notConnectedToInternet, but no error was thrown")
        } catch {
            // Then
            XCTAssertEqual((error as? URLError)?.code, URLError.notConnectedToInternet)
        }
    }
    
    func testPerformErrorInDecode() async throws {
        // Given
        let httpClient = DefaultHTTPClient(perform: mockErrorDecode)
        
        do {
            // When
            let _: TestResponse = try await httpClient.perform(request: URLRequest(url: URL(string: "http://example.com")!))
            XCTFail("Expected DecodingError, but no error was thrown")
        } catch {
            // Then
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testPerform() async throws {
        // Given
        let httpClient = DefaultHTTPClient(perform: mockPerform)
        let expectedResult = TestResponse(message: "Hello, world!")
        
        // When
        let result: TestResponse = try await httpClient.perform(request: URLRequest(url: URL(string: "http://example.com")!))
        
        // Then
        XCTAssertEqual(result.message, expectedResult.message)
    }
    
}
