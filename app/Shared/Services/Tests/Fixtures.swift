//
//  Fixtures.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation
@testable import Services

// swiftlint:disable all
final class Fixtures {
  
  static func data(contentOf filename: String, withExtension ext: String) -> Data {
      guard let url = Bundle.module.url(forResource: filename, withExtension: ext),
            let data = try? Data(contentsOf: url)
      else { fatalError("No file found for fixture with name `\(filename)`.") }
      return data
  }
}
