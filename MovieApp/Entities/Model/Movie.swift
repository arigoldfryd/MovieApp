//
//  Movie.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

class Movie: Identifiable, Hashable, Equatable, Codable {
    
    private(set) var id: Int
    let title: String
    let genres: [Genre]
    let posterPath: URL?
    let backdropPath: URL?
    let overview: String
    let releaseDate: String
    
    init(id: Int, title: String, genres: [Genre], posterPath: URL?, backdropPath: URL?, overview: String, releaseDate: String) {
        self.id = id
        self.title = title
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, genres, posterPath, backdropPath, overview, releaseDate
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        genres = try container.decode([Genre].self, forKey: .genres)
        posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(genres, forKey: .genres)
        try container.encode(posterPath, forKey: .posterPath)
        try container.encode(backdropPath, forKey: .backdropPath)
        try container.encode(overview, forKey: .overview)
        try container.encode(releaseDate, forKey: .releaseDate)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
