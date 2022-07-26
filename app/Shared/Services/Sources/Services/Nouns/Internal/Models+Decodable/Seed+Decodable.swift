// Copyright (C) 2022 Nouns Collective
//
// Originally authored by  Ziad Tamim
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

extension Seed: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    guard let backgroundInt = Int(try container.decode(String.self, forKey: AnyCodingKey("background"))),
          let glassesInt = Int(try container.decode(String.self, forKey: AnyCodingKey("glasses"))),
          let headInt = Int(try container.decode(String.self, forKey: AnyCodingKey("head"))),
          let bodyInt = Int(try container.decode(String.self, forKey: AnyCodingKey("body"))),
          let accessoryInt = Int(try container.decode(String.self, forKey: AnyCodingKey("accessory")))
    else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not convertible to an Integer")
      
      throw DecodingError.dataCorrupted(context)
    }
    
    background = backgroundInt
    glasses = glassesInt
    head = headInt
    body = bodyInt
    accessory = accessoryInt
  }
}
