//
//  MockHTTPClient.swift
//  MovieAppTests
//
//  Created by Ariel on 03/08/2023.
//

import Foundation
@testable import MovieApp

class MockHTTPClient: HTTPClient {
    var responseData: Data?
    var responseError: Error?
    
    func perform<T>(request: URLRequest) async throws -> T where T: Decodable {
        if let error = responseError {
            throw error
        }
        
        guard let responseData = responseData else {
            fatalError("Response data not set for MockHTTPClient")
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: responseData)
    }
}
