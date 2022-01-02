//
//  LiveAuctionListener.swift
//  
//
//  Created by Ziad Tamim on 02.01.22.
//

import Foundation

class LiveAuctionListener {
  ///
  typealias ListenerContinuation = AsyncStream<Auction>.Continuation
  
  ///
  private var continuation: ListenerContinuation?
  
  ///
  private weak var graphQLClient: GraphQL?
  
  ///
  private var timer: DispatchSourceTimer = {
    let queue = DispatchQueue(
      label: "wtf.nouns.ios.live-auction",
      qos: .userInitiated
    )
    let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: .now(), repeating: .seconds(1))
    return timer
  }()
  
  
  init(continuation: ListenerContinuation, graphQLClient: GraphQL) {
    self.continuation = continuation
    self.graphQLClient = graphQLClient
    
    timer.setEventHandler { [weak self] in
      guard let self = self else { return }
      
      Task {
        do {
          let auction = try await self.fetchLiveAuction()
          continuation.yield(auction)
        } catch { }
      }
    }
    
    timer.resume()
  }
  
  private func fetchLiveAuction() async throws -> Auction {
    let query = NounsSubgraph.LiveAuctionSubscription()
    let page: Page<[Auction]>? = try await graphQLClient?.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )

    guard let auction = page?.data.first else {
      throw OnChainNounsRequestError.noData
    }
    
    return auction
  }
}
