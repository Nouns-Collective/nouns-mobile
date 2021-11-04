//
//  NounsComposerTests.swift
//  ServicesTests
//
//  Created by Ziad Tamim on 23.10.21.
//

import XCTest
@testable import Services

protocol NounsComposerFake {
  static var backgrounds: [Trait] { get }
  static var palette: [String] { get }
  static var bodies: [Trait] { get }
  static var accessories: [Trait] { get }
  static var heads: [Trait] { get }
  static var glasses: [Trait] { get }
}

final class NounsComposerTests: XCTestCase {
  
}
