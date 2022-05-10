//
//  NounComposer.swift
//  Services
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation

/// The Noun's trait.
public struct Trait: Equatable, Hashable {
  
  /// `RLE` data compression of the Noun's trait.
  public let rleData: String
  
  /// Asset image of the Noun's trait stored locally.
  public let assetImage: String
  
  /// Textures to animate different parts of the traits.
  public let textures: [String: [String]]
}

/// This provider class allows interacting with local Nouns' placed in disk.
public protocol NounComposer {
  
  /// The color palette used to draw Noun's background.
  var backgroundColors: [String] { get }
  
  /// The color palette used to draw Noun's parts.
  var palette: [String] { get }
  
  /// Array containing all the bodies mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var bodies: [Trait] { get }
  
  /// Array containing all the accessories mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var accessories: [Trait] { get }
  
  /// Array containing all the heads mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var heads: [Trait] { get }
  
  /// Array containing all the glasses mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var glasses: [Trait] { get }
  
  /// Generates a random seed, given the number of each trait type
  func randomSeed() -> Seed

  /// Generates a new random seed, with no trait values in common with the `previous` seed
  func newRandomSeed(previous seed: Seed) -> Seed
  
}

/// A Flavour of the NounComposer to load local Nouns' trait.
public class OfflineNounComposer: NounComposer {
  
  /// The background list of colors.
  public lazy var backgroundColors = layer.bgcolors
  
  /// The color palette used to draw `Nouns` with `RLE` data.
  public lazy var palette = layer.partcolors
  
  /// The body list of traits.
  public lazy var bodies = layer.parts[0]
  
  /// The accessory list of traits.
  public lazy var accessories = layer.parts[1]
  
  /// The head list of traits.
  public lazy var heads = layer.parts[2]
  
  /// The glasses list of traits.
  public lazy var glasses = layer.parts[3]
  
  /// Decodes offline Noun's traits.
  private struct Layer: Decodable {
    let partcolors: [String]
    let bgcolors: [String]
    let parts: [[Trait]]
  }
  
  private let layer: Layer
  
  init(encodedLayersURL: URL) throws {
    let data = try Data(contentsOf: encodedLayersURL)
    layer = try JSONDecoder().decode(Layer.self, from: data)
  }
  
  /// Creates and returns an `NounComposer` object from an existing set of Nouns' traits.
  /// - Returns: A new NounComposer object.
  public static func `default`() -> NounComposer {
    do {
      guard let url = Bundle.module.url(
        forResource: "nouns-traits-layers",
        withExtension: "json"
      ) else {
        throw URLError(.badURL)
      }
      
      return try OfflineNounComposer(encodedLayersURL: url)
      
    } catch {
      fatalError("💥 Failed to create the offline nouns composer \(error)")
    }
  }
  
  /// Generates a random seed, given the number of each trait type
  public func randomSeed() -> Seed {
    guard let background = backgroundColors.randomIndex(),
          let body = bodies.randomIndex(),
          let accessory = accessories.randomIndex(),
          let head = heads.randomIndex(),
          let glasses = glasses.randomIndex() else {
            return Seed(background: 0, glasses: 0, head: 0, body: 0, accessory: 0)
          }
    
    return Seed(background: background, glasses: glasses, head: head, body: body, accessory: accessory)
  }

  public func newRandomSeed(previous seed: Seed) -> Seed {
    var result: Seed
    repeat {
      result = randomSeed()
    } while result.background == seed.background
    || result.body == seed.body
    || result.accessory == seed.accessory
    || result.head == seed.head
    || result.glasses == seed.glasses

    return result
  }
}

extension Trait: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case assetImage = "name"
    case rleData = "data"
    case textures
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    rleData = try container.decode(String.self, forKey: .rleData)
    assetImage = try container.decode(String.self, forKey: .assetImage)
    textures = try container.decode([String: [String]].self, forKey: .textures)
  }
}

fileprivate extension Array {
  
  func randomIndex() -> Int? {
    guard self.count > 0 else { return nil }
    
    let minIndex = 0
    let maxIndex = self.count - 1
    
    return Int.random(in: minIndex...maxIndex)
  }
}
