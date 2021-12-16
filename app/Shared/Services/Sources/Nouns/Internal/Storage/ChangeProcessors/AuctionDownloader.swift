//
//  AuctionDownloader.swift
//  
//
//  Created by Ziad Tamim on 14.12.21.
//

import Foundation
import Combine

final class AuctionDownloader: ChangeProcessor {
  
  func processCloudChanges(in context: ChangeProcessContext) {
    
  }
  
  func fetchCloudEntities(in context: ChangeProcessContext, limit: Int, cursor: Int) async throws {
    let auctions = try await context.cloud.fetchAuctions(
      settled: true,
      limit: limit,
      cursor: cursor
    )
    
  }
  
}
