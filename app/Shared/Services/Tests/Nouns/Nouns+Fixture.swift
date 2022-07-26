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
@testable import Services

/// Various `Auction` fixtures.
extension Auction {
  
  static func fixture(startTime: TimeInterval? = nil, endTime: TimeInterval? = nil) -> Auction {
    Auction(
      id: "106",
      noun: .fixture(),
      amount: "1636758555",
      startTime: startTime ?? 1636758555,
      endTime: endTime ?? 1636844955,
      settled: false,
      bidder: .fixture
    )
  }
  
  static var fixtureLiveNewBid: Self = {
    Auction(
      id: "106",
      noun: .fixture(),
      amount: "3500000000000000000",
      startTime: 1636758555,
      endTime: 1636844955,
      settled: false,
      bidder: .fixture
    )
  }()
  
  static var fixtureLiveSettled: Self = {
    Auction(
      id: "106",
      noun: .fixture(),
      amount: "4500000000000000000",
      startTime: 1636758555,
      endTime: 1636844955,
      settled: true,
      bidder: .fixture
    )
  }()
  
  static var fixtureLiveNew: Self = {
    Auction(
      id: "107",
      noun: .fixture(),
      amount: "1000000000000000000",
      startTime: 1636758555,
      endTime: 1636844955,
      settled: false,
      bidder: .fixture
    )
  }()
}

/// Various `Noun` fixtures.
extension Noun {
  
  static func fixture(
    id: String = "0",
    name: String = "Untitled",
    createdAt: Date = .now
  ) -> Self {
    Noun(
      id: id,
      name: name,
      owner: .fixture,
      seed: .fixture,
      createdAt: createdAt,
      updatedAt: .now
    )
  }
}

/// Various `Seed` fixtures.
extension Seed {
  
  static var fixture: Self = {
    Seed(
      background: 0,
      glasses: 18,
      head: 94,
      body: 14,
      accessory: 132
    )
  }()
}

/// Various `Bid` fixtures.
extension Bid {
  
  static var fixture: Self = {
    Bid(
      id: "0xaf1efeeaedf13ad7cbaa66661d9411f6118ac4e4884daae6a3b81ab12d15f082",
      amount: "100000000000000000",
      blockTimestamp: "1628443478",
      bidder: .fixture)
  }()
}

/// Various `Account` fixtures.
extension Account {
  
  static var fixture: Self = {
    Account(id: "0x2573c60a6d127755aa2dc85e342f7da2378a0cc5")
  }()
}

/// Various `Proposal` fixtures.
extension Proposal {
  
  static var fixture: Self = {
    Proposal(
      id: "14",
      title: "setProposalThresholdBPS(50)",
      description: "# setProposalThresholdBPS(50)\n\n===thank you for your consideration ",
      status: .queued,
      votes: [],
      quorumVotes: 0,
      executionETA: nil,
      createdTimestamp: nil
    )
  }()
}

/// Various `Vote` fixtures.
extension Vote {
  
  static var fixture: Self = {
    Vote(
      id: "0x2536c09e5f5691498805884fa37811be3b2bddb4-1",
      supportDetailed: .for,
      proposal: .fixture)
  }()
}
