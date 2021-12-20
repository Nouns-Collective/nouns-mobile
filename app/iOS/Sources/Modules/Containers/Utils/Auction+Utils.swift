//
//  Auction+Formatter.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services
import Combine

extension Auction {
  
  var componentsSequence: AnyPublisher<DateComponents, Never> {
    // Timer sequence to emit every 1 second.
    Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .compactMap { _ -> DateComponents? in
        guard let endDateTimeInterval = Double(self.endTime) else {
          return nil
        }

        let now = Date()
        let end = Date(timeIntervalSince1970: endDateTimeInterval)
        return Calendar.current.dateComponents(
          [.hour, .minute, .second],
          from: now,
          to: end
        )
      }
      .eraseToAnyPublisher()
  }
}
