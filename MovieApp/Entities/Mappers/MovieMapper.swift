//
//  MovieMapper.swift
//  MovieApp
//
//  Created by Ariel on 02/08/2023.
//

import Foundation

protocol MovieMapper {
    func mapDTOToModel(movies: [MovieDTO], genres: [Genre]) -> [Movie]
}

class DefaultMovieMapper: MovieMapper {
    enum ImagePath: String {
        case w780, original
        
        func getURL(adding path: String) -> URL? {
            return URL(string: "https://image.tmdb.org/t/p/\(self.rawValue)\(path)")
        }
    }
    
    func mapDTOToModel(movies: [MovieDTO], genres: [Genre]) -> [Movie] {
        let genreDictionary: [Int: Genre] = Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0) })

        return movies.map { movieDTO in
            let mappedGenres = movieDTO.genreIds.compactMap { genreID in
                genreDictionary[genreID]
            }

            let posterPathURL: URL? = movieDTO.posterPath.flatMap { ImagePath.w780.getURL(adding: $0) }
            let backdropPathURL: URL? = movieDTO.backdropPath.flatMap { ImagePath.original.getURL(adding: $0) }

            var releaseYear = ""
            if let date = movieDTO.releaseDate.convertToDate() {
                releaseYear = "\(Calendar.current.component(.year, from: date))"
            }
            
            return Movie(id: movieDTO.id, title: movieDTO.title, genres: mappedGenres, posterPath: posterPathURL, backdropPath: backdropPathURL, overview: movieDTO.overview, releaseDate: releaseYear)
        }
    }
}
