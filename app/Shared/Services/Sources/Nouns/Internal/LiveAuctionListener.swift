//
//  LiveAuctionListener.swift
//  
//
//  Created by Ziad Tamim on 02.01.22.
//

import Foundation

/// `Short-Poll` implementation to handle non-settled auction changes.
class LiveAuctionListener {
  /// Stream continuation type.
  typealias ListenerContinuation = AsyncStream<Auction>.Continuation
  
  /// Stream continuation to populate auction changes.
  private var continuation: ListenerContinuation?
  
  /// The graphQL client reference to update the current live auction.
  private weak var graphQLClient: GraphQL?
  
  /// `Short-Poll` interval.
  private let pollingInterval = 1
  
  /// A dispatch source that submits the event handler block based on timer.
  private lazy var timer: DispatchSourceTimer = {
    let queue = DispatchQueue(
      label: "wtf.nouns.ios.live-auction",
      qos: .userInitiated
    )
    let timer = DispatchSource.makeTimerSource(queue: queue)
    timer.schedule(deadline: .now(), repeating: .seconds(pollingInterval))
    return timer
  }()
  
  
  init(continuation: ListenerContinuation, graphQLClient: GraphQL) {
    self.continuation = continuation
    self.graphQLClient = graphQLClient
  }
  
  func startPolling() {
    handlePollingEvent()
    
    continuation?.onTermination = { @Sendable [weak self] termination in
      self?.stopPolling()
    }
  }
  
  func stopPolling() {
    timer.cancel()
  }
  
  deinit {
    stopPolling()
  }
  
  private func handlePollingEvent() {
    timer.setEventHandler { [weak self] in
      guard let self = self else { return }
      
      Task {
        do {
          guard !self.timer.isCancelled else {
            return
          }
          
          let auction = try await self.fetchLiveAuction()
          self.continuation?.yield(auction)
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
