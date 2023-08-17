//
//  File.swift
//  MovieApp
//
//  Created by Ariel on 31/07/2023.
//

import Foundation

protocol LocalClient {
    func get<T>(forKey key: String) throws -> T? where T: Codable
    func set<T: Encodable>(value: T, forKey key: String) throws
}

class DefaultLocalClient: LocalClient {
    typealias SetMethod = (Any?, String) -> Void
    typealias GetMethod = (String) -> Data?
    
    private let setValue: SetMethod
    private let getValue: GetMethod
    
    init(set: @escaping SetMethod = UserDefaults.standard.set,
         get: @escaping GetMethod = UserDefaults.standard.data) {
        self.setValue = set
        self.getValue = get
    }
    
    func set<T: Encodable>(value: T, forKey key: String) throws {
        let encodedData = try JSONEncoder().encode(value)
        setValue(encodedData, key)
    }
    
    func get<T>(forKey key: String) throws -> T? where T : Decodable, T : Encodable {
        guard let encodedData = getValue(key) else { return nil }
        return try JSONDecoder().decode(T.self, from: encodedData)
    }
}
