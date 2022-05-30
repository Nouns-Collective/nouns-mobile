//
//  Formatter+Utils.swift
//  Nouns
//
//  Created by Ziad Tamim on 02.12.21.
//

import Foundation

extension Date {
  
  func formatted(
    dateStyle: DateFormatter.Style = .long,
    timeStyle: DateFormatter.Style = .none
  ) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateStyle = dateStyle
    dateFormatter.timeStyle = timeStyle
    return dateFormatter.string(from: self)
  }
}
