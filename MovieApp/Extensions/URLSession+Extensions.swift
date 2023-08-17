//
//  URLSession+Extensions.swift
//  MovieApp
//
//  Created by Ariel on 03/08/2023.
//

import Foundation

extension URLSession {
    static var cached: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache.shared
        configuration.requestCachePolicy = .useProtocolCachePolicy

        return URLSession(configuration: configuration)
    }
}
