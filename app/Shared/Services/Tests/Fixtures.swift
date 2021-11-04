//
//  Fixtures.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation
@testable import Services

final class Fixtures {
  
  static func data(contentOf filename: String, withExtension ext: String) -> Data {
      let url = Bundle.module.url(forResource: filename, withExtension: ext)!
      return try! Data(contentsOf: url)
  }
}
