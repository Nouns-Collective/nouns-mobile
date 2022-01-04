//
//  Auction+Formatter.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension Auction {
  
  var components: DateComponents? {
    guard let endDateTimeInterval = Double(endTime) else {
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
}
