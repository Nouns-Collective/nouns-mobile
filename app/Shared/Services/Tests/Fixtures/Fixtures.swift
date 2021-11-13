//
//  Fixtures.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation
@testable import Services

final class Fixtures {
    
    static func data(contentOf filename: String, withExtension ext: String) -> Data {
        guard let url = Bundle.module.url(forResource: filename, withExtension: ext),
              let data = try? Data(contentsOf: url)
        else {
            fatalError("No file found for fixture with name `\(filename)`.")
        }
        return data
    }
    
    static var validNouns: [Noun] {
        [
            Noun(
                id: "0",
                owner: Account(id: "0x2573c60a6d127755aa2dc85e342f7da2378a0cc5"),
                seed: Seed(
                    background: 0,
                    glasses: 18,
                    head: 94,
                    body: 14,
                    accessory: 132)
            ),
            Noun(
                id: "1",
                owner: Account(id: "0x2536c09e5f5691498805884fa37811be3b2bddb4"),
                seed: Seed(
                    background: 1,
                    glasses: 14,
                    head: 88,
                    body: 20,
                    accessory: 95)
            )
        ]
    }
    
    static var validActivities: [Vote] {
        [
            Vote(
                supportDetailed: .for,
                proposal: Proposal(
                    id: "14",
                    title: "Brave Sponsored Takeover during NFT NYC",
                    description: "# Brave Sponsored Takeover during NFT NYC\n\n### Proposal\n\nBrave proposes a partnership between Nouns DAO and the browser’s native ad unit: Sponsored Images, to come together and use the 24 hour takeovers as a space to showcase the Nouns project on the first day of NFT NYC (November 1st, 2021)\n\n### Details\n\nRegion: USA\nFlight Dates: 11/1/2021\nEstimated Impressions: 11,000,000\nNouns DAO Rate: 11.89 ETH\n\n- Nouns DAO representative (4156) will Docusign agreement and Nouns DAO will execute payment when this proposal passes\n- Community members will provide artwork for 3 sponsored images in collaboration with Brave Ads team (see #brave-takeover in Nouns Discord) and will be compensated via the retroactive funding group\n- Images will appear in rotation for 24h from November 1 at 00:00 AM EST until November 1 at 11:59 PM EST",
                    status: .queued)
            ),
            Vote(
                supportDetailed: .for,
                proposal: Proposal(
                    id: "15",
                    title: "setProposalThresholdBPS(50)",
                    description: "# setProposalThresholdBPS(50)\n\n===thank you for your consideration ",
                    status: .queued)
            ),
        ]
    }
    
    static var auction: Auction {
        Auction(
            id: "106",
            noun: Noun(
                id: "106",
                owner: Account(id: "0x830bd73e4184cef73443c15111a1df14e495c706"),
                seed: Seed(
                    background: 1,
                    glasses: 16,
                    head: 230,
                    body: 0,
                    accessory: 81
                )
            ),
            amount: "2000000000000000000",
            startTime: "1636758555",
            endTime: "1636844955",
            settled: false,
            bids: [
                Bid(id: "0xaf1efeeaedf13ad7cbaa66661d9411f6118ac4e4884daae6a3b81ab12d15f082", amount: "100000000000000000"),
                Bid(id: "0xcc9b27ae49d84e14103ee7abb52b23e050d2e5f2a4e7b0655177dcf4eed4bcb2", amount: "2000000000000000000"),
            ]
        )
    }
}
