//
//  File.swift
//  
//
//  Created by Ziad Tamim on 14.11.21.
//

import Foundation
@testable import Services

/// Various `Auction` fixtures.
extension Auction {
  
  static var fixture: Self = {
    Auction(
      id: "106",
      noun: .fixture(),
      amount: "2000000000000000000",
      startTime: "1636758555",
      endTime: "1636844955",
      settled: false
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
      status: .queued
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
