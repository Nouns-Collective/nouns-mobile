//
//  LiveAuctionListener.swift
//  
//
//  Created by Ziad Tamim on 02.01.22.
//

import Foundation

/// `Short-Poll` implementation to handle non-settled auction changes.
class ShortPolling<T> {
  /// Stream continuation type.
  typealias ListenerContinuation = AsyncStream<T>.Continuation
  
  /// Stream continuation to populate auction changes.
  private var continuation: ListenerContinuation?
  
  /// Action to perform on each event.
  private let action: @Sendable () async throws -> T
  
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
  
  init(
    continuation: ListenerContinuation,
    action: @Sendable @escaping () async throws -> T
  ) {
    self.continuation = continuation
    self.action = action
  }
  
  func startPolling() {
    handlePollingEvent()
    
    continuation?.onTermination = { @Sendable [weak self] _ in
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
          
          let auction = try await self.action()
          self.continuation?.yield(auction)
        } catch { }
      }
    }
    
    timer.resume()
  }
}
