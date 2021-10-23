//
//  NounComposer.swift
//  Services
//
//  Created by Ziad Tamim on 23.10.21.
//

import Foundation

/// The Noun's trait.
public struct Part {
  
  /// `RLE` data compression of the Noun's trait.
  public let rleData: String
  
  /// Asset image of the Noun's trait stored locally.
  internal let assetImage: String
  
  /// Load Noun's trait bundled image.
  public lazy var data: Data? = {
    guard
      let url = Bundle.main.url(forResource: assetImage, withExtension: "png")
    else { return nil }
    return try? Data(contentsOf: url)
  }()
}

/// This provider class allows interacting with local Nouns' placed in disk.
public protocol NounComposer {
  
  /// The color palette used to draw Noun's background.
  var backgroundColors: [String] { get }
  
  /// The color palette used to draw Noun's parts.
  var palette: [String] { get }
  
  /// Array containing all the bodies mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var bodies: [Part] { get }
  
  /// Array containing all the accessories mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var accessories: [Part] { get }
  
  /// Array containing all the heads mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var heads: [Part] { get }
  
  /// Array containing all the glasses mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var glasses: [Part] { get }
}

public class OfflineNounComposer: NounComposer {
  
  public lazy var backgroundColors: [String] = {
    layer.bgcolors
  }()
  
  public lazy var palette: [String] = {
    layer.partcolors
  }()
  
  public lazy var bodies: [Part] = {
    layer.parts[0]
  }()
  
  public lazy var accessories: [Part] = {
    layer.parts[1]
  }()
  
  public lazy var heads: [Part] = {
    layer.parts[2]
  }()
  
  public lazy var glasses: [Part] = {
    layer.parts[3]
  }()
  
  /// Decodes offline Noun's traits.
  private struct Layer: Decodable {
    let partcolors: [String]
    let bgcolors: [String]
    let parts: [[Part]]
  }
  
  private let layer: Layer
  
  public init(encodedLayersURL: URL) throws {
    let data = try Data(contentsOf: encodedLayersURL)
    layer = try JSONDecoder().decode(Layer.self, from: data)
  }
}

extension Part: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case assetImage = "name"
    case rleData = "data"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    rleData = try container.decode(String.self, forKey: .rleData)
    assetImage = try container.decode(String.self, forKey: .assetImage)
  }
}
