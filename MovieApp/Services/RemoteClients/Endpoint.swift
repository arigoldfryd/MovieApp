//
//  Endpoint.swift
//  MovieApp
//
//  Created by Ariel on 03/08/2023.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/" + path
        components.queryItems = [
            URLQueryItem(name: "api_key", value: Bundle.main.infoDictionary?["API_KEY"] as? String)
        ]
        components.queryItems?.append(contentsOf: queryItems)
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}
