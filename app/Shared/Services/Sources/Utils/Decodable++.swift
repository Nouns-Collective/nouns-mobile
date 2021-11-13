//
//  Decodable+Shortcut.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

extension Decoder {
    
    /// Decode a nested value for array of keys, specified as a `CodingKey`.
    /// Throws an error if keys array is empty
    func decode<T: Decodable>(_ keys: [CodingKey], as type: T.Type = T.self) throws -> T {
        
        let keys = keys.map { AnyCodingKey($0.stringValue) }
        
        var container = try self.container(keyedBy: AnyCodingKey.self)
        for key in keys.dropLast() {
            container = try container.nestedContainer(keyedBy: AnyCodingKey.self, forKey: key)
        }
        return try container.decode(type, forKey: keys.last!)
    }
    
    /// Decode a nested value for array of keys, specified as a string.
    /// Throws an error if keys array is empty
    func decode<T: Decodable>(_ keys: String..., as type: T.Type = T.self) throws -> T {
        try decode(keys.map { AnyCodingKey($0) })
    }
}

// MARK: - internal supporting types

internal struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(_ string: String) {
        stringValue = string
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}
