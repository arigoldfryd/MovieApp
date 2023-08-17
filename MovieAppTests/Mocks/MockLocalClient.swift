//
//  MockLocalClient.swift
//  MovieAppTests
//
//  Created by Ariel on 04/08/2023.
//

import Foundation
@testable import MovieApp

class MockLocalClient: LocalClient {
    var storedData: [String: Any] = [:]
    
    func set<T>(value: T, forKey key: String) throws where T : Encodable {
        storedData[key] = value
    }
    
    func get<T>(forKey defaultName: String) throws -> T? {
        return storedData[defaultName] as? T
    }
    
    func remove(forKey defaultName: String) throws {
        storedData.removeValue(forKey: defaultName)
    }
}
