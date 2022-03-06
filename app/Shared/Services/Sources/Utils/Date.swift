//
//  File.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-03-05.
//

import Foundation

extension Date {
  
  /// Date after a specified number of weeks
  func dateAfter(hours: Int = 0, days: Int = 0, weeks: Int = 0) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.weekOfYear = weeks
    dateComponents.day = days
    dateComponents.hour = hours
    return Calendar.current.date(byAdding: dateComponents, to: self)
  }
}
