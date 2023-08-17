//
//  MovieResponse.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [MovieDTO]
    let totalPages: Int
    let totalResults: Int
}
