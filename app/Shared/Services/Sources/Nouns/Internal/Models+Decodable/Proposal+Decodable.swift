//
//  Proposal+Decodable.swift
//  
//
//  Created by Ziad Tamim on 18.12.21.
//

import Foundation

extension Proposal: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    status = try container.decode(ProposalStatus.self, forKey: AnyCodingKey("status"))
    description = try container.decode(String.self, forKey: AnyCodingKey("description"))
    title = MarkdownParser(content: description).title
  }
}
