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

extension Auction {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    noun = try container.decode(Noun.self, forKey: AnyCodingKey("noun"))
    amount = try container.decode(String.self, forKey: AnyCodingKey("amount"))
    bidder = try container.decodeIfPresent(Account.self, forKey: AnyCodingKey("bidder"))
    settled = try container.decode(Bool.self, forKey: AnyCodingKey("settled"))
    
    let startTimeAsString = try container.decode(String.self, forKey: AnyCodingKey("startTime"))
    let endTimeAsString = try container.decode(String.self, forKey: AnyCodingKey("endTime"))
    
    startTime = try TimeIntervalDecoder.timeInterval(startTimeAsString, decoder)
    endTime = try TimeIntervalDecoder.timeInterval(endTimeAsString, decoder)
  }
}
