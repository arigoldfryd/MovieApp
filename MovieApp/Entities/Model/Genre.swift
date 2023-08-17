//
//  Genre.swift
//  MovieApp
//
//  Created by Ariel on 29/07/2023.
//

import Foundation

class Genre: Hashable, Equatable, Codable {
    let id: Int
    let name: String
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
