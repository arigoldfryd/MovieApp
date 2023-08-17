//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Ariel on 02/08/2023.
//

import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var movies: [Movie]?
    @Published var error: Error?
    
    private let movieMapper: MovieMapper
    private let genreService: GenreService
    private let searchService: SearchService
    
    init(movieMapper: MovieMapper = DefaultMovieMapper(),
         genreService: GenreService = DefaultGenreService(),
         searchService: SearchService = DefaultMovieService()) {
        self.movieMapper = movieMapper
        self.genreService = genreService
        self.searchService = searchService
    }
    
    func searchMovies(by text: String) async {
        do {
            async let moviesResponse = try searchService.searchMovies(by: text)
            async let genresResponse = try genreService.getGenres()
            try await updateData(moviesResponse: moviesResponse, genresResponse: genresResponse)
        } catch {
            self.error = error
        }
    }
    
    func cleanResults() {
        movies = nil
    }
    
    private func updateData(moviesResponse: MovieResponse, genresResponse: GenreResponse) {
        movies = movieMapper.mapDTOToModel(movies: moviesResponse.results, genres: genresResponse.genres)
    }
}
