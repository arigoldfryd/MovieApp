//
//  DiscoveryService.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

protocol DiscoveryService {
    func getMovies(page: Int) async throws -> MovieResponse
}

class DefaultMovieService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = DefaultHTTPClient()) {
        self.httpClient = httpClient
    }
}

extension DefaultMovieService: DiscoveryService {
    func getMovies(page: Int) async throws -> MovieResponse {
        let urlRequest = URLRequest(url: Endpoint.discoverMovie(page: page).url)
        return try await httpClient.perform(request: urlRequest)
    }
}

extension Endpoint {
    static func discoverMovie(page: Int) -> Self {
        Endpoint(
            path: "discover/movie",
            queryItems: [URLQueryItem(
                name: "page",
                value: "\(page)"
            )]
        )
    }
}
