//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-19.
//

import Foundation

internal class TimeIntervalDecoder {
  
  internal static func timeInterval(
    _ timeIntervalAsString: String,
    _ decoder: Decoder
  ) throws -> TimeInterval {
    
    guard let timeInterval = TimeInterval(timeIntervalAsString) else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not convertible to an TimeInterval")
      
      throw DecodingError.dataCorrupted(context)
    }
    
    return timeInterval
  }
}
