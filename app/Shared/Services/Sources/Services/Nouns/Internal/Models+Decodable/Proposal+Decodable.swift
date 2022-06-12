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

extension Proposal: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    status = try container.decode(ProposalStatus.self, forKey: AnyCodingKey("status"))
    description = try container.decode(String.self, forKey: AnyCodingKey("description"))
    title = MarkdownParser(content: description).title
    votes = try container.decode([ProposalVote].self, forKey: AnyCodingKey("votes"))
    
    let quorumVotesAsString = try container.decode(String.self, forKey: AnyCodingKey("quorumVotes"))
    quorumVotes = Int(quorumVotesAsString) ?? 0
    
    if let executionETAAsString = try container.decodeIfPresent(String.self, forKey: AnyCodingKey("executionETA")) {
      executionETA = try TimeIntervalDecoder.timeInterval(executionETAAsString, decoder)
    } else {
      executionETA = nil
    }
    
    if let createdTimestampAsString = try container.decodeIfPresent(String.self, forKey: AnyCodingKey("createdTimestamp")) {
      createdTimestamp = try TimeIntervalDecoder.timeInterval(createdTimestampAsString, decoder)
    } else {
      createdTimestamp = nil
    }
  }
}
