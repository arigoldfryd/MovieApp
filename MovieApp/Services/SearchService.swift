//
//  SearchService.swift
//  MovieApp
//
//  Created by Ariel on 02/08/2023.
//

import Foundation

protocol SearchService {
    func searchMovies(by text: String) async throws -> MovieResponse
}

extension DefaultMovieService: SearchService {
    func searchMovies(by text: String) async throws -> MovieResponse {
        let urlRequest = URLRequest(url: Endpoint.search(by: text).url)
        return try await httpClient.perform(request: urlRequest)
    }
}

extension Endpoint {
    static func search(by query: String) -> Self {
        Endpoint(
            path: "search/movie",
            queryItems: [URLQueryItem(
                name: "query",
                value: query
            )]
        )
    }
}
