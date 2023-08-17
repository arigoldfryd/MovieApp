//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Ariel on 28/07/2023.
//

import Foundation

@MainActor
class MovieListViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var error: Error?
    
    private var page = 0
    private var totalPages = Int.max
    
    private let discoveryService: DiscoveryService
    private let genreService: GenreService
    private let movieMapper: MovieMapper
    
    init(discoveryService: DiscoveryService = DefaultMovieService(),
         genreService: GenreService = DefaultGenreService(),
         movieMapper: MovieMapper = DefaultMovieMapper()) {
        self.discoveryService = discoveryService
        self.genreService = genreService
        self.movieMapper = movieMapper
    }
    
    func getMovies() async {
        if page == totalPages {
            return
        }
        
        page += 1
        do {
            async let moviesResponse = try discoveryService.getMovies(page: page)
            async let genresResponse = try genreService.getGenres()
            try await updateData(moviesResponse: moviesResponse, genresResponse: genresResponse)
        } catch {
            self.error = error
        }
    }
    
    private func updateData(moviesResponse: MovieResponse, genresResponse: GenreResponse) {
        let mappedMovies = movieMapper.mapDTOToModel(movies: moviesResponse.results, genres: genresResponse.genres)
        movies.append(contentsOf: mappedMovies)
        totalPages = moviesResponse.totalPages
    }
}
