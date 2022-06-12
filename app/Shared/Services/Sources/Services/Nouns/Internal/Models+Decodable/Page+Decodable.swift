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

extension Page: Decodable {
  
  public init(from decoder: Decoder) throws {
    if T.self == [Noun].self {
      data = try decoder.decode("data", "nouns")
      
    } else if T.self == [Vote].self {
      data = try decoder.decode("data", "noun", "votes")
      
    } else if T.self == [ENSDomain].self {
      data = try decoder.decode("data", "domains")
      
    } else if T.self == [Auction].self {
      data = try decoder.decode("data", "auctions")
      
    } else if T.self == [Proposal].self {
      data = try decoder.decode("data", "proposals")
      
    } else if T.self == [Bid].self {
      data = try decoder.decode("data", "bids")
      
    } else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not of an expected type")
      
      throw DecodingError.typeMismatch(T.self, context)
    }
  }
}
