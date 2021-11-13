//
//  Pageable.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

/// Pagination.
public struct Page<T>: Decodable where T: Decodable {
    
    /// Data retrived from the response.
    public let data: T
    
    public init(from decoder: Decoder) throws {
        if T.self == [Noun].self {
            data = try decoder.decode("data", "nouns")
            
        } else if T.self == [Vote].self {
            data = try decoder.decode("data", "noun", "votes")
            
        } else if T.self == [ENSDomain].self {
            data = try decoder.decode("data", "domains")
            
        } else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Encoded payload not of an expected type")
            
            throw DecodingError.typeMismatch(T.self, context)
        }
    }
}
