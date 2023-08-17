//
//  GenreService.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

protocol GenreService {
    func getGenres() async throws -> GenreResponse
}

class DefaultGenreService: GenreService {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = DefaultHTTPClient()) {
        self.httpClient = httpClient
    }
    
    func getGenres() async throws -> GenreResponse {
        let urlRequest = URLRequest(url: Endpoint.genres.url)
        return try await httpClient.perform(request: urlRequest)
    }
}

extension Endpoint {
    static var genres: Self {
        Endpoint(path: "genre/movie/list")
    }
}
