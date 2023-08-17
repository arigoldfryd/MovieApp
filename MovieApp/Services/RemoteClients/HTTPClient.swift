//
//  HTTPClient.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

protocol HTTPClient {
    func perform<T>(request: URLRequest) async throws -> T where T: Decodable
}

class DefaultHTTPClient: HTTPClient {
    typealias PerformRequest = (URLRequest) async throws -> (Data, URLResponse)
    
    private let perform: PerformRequest
    
    init(perform: @escaping PerformRequest = URLSession.cached.data) {
        self.perform = perform
    }
    
    func perform<T>(request: URLRequest) async throws -> T where T: Decodable {
        let (data, _) = try await perform(request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: data)
    }
}
