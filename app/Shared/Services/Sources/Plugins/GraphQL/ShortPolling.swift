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

/// `Short-Poll` implementation to handle non-settled auction changes.
class ShortPolling<T> {
  
  /// Action to perform on each event.
  private let action: @Sendable () async throws -> T
  
  var setEventHandler: ((T) -> Void)?
  
  var setErrorHandler: ((Error) -> Void)?

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
  
  init(action: @Sendable @escaping () async throws -> T) {
    self.action = action
  }
  
  func startPolling() {
    handlePollingEvent()
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
          self.setEventHandler?(auction)
          
        } catch {
          self.setErrorHandler?(error)
        }
      }
    }
    
    timer.resume()
  }
}
