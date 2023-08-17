//
//  MovieDTO.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

struct MovieDTO: Codable, Equatable {
    let id: Int
    let title: String
    let genreIds: [Int]
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String
}
