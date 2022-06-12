// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import Foundation

extension Decoder {
    
    /// Decode a nested value for array of keys, specified as a `CodingKey`.
    /// Throws an error if keys array is empty
    func decode<T: Decodable>(_ keys: [CodingKey], as type: T.Type = T.self) throws -> T {
        let keys = keys.map { AnyCodingKey($0.stringValue) }
        
        var container = try self.container(keyedBy: AnyCodingKey.self)
        for key in keys.dropLast() {
            container = try container.nestedContainer(
                keyedBy: AnyCodingKey.self,
                forKey: key)
        }
        
        guard let lastKey = keys.last else {
            let context = DecodingError.Context(
                codingPath: keys,
                debugDescription: "Empty nested CodingKeys.")
            
            throw DecodingError.dataCorrupted(context)
        }
        
        return try container.decode(type, forKey: lastKey)
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
