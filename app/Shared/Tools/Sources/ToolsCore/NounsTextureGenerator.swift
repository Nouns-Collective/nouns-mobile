//
//  Nouns.swift
//  
//
//  Created by Ziad Tamim on 12.02.22.
//

import Foundation
import TabularData
import ArgumentParser

/// Decodes offline Noun's traits.
struct Layer: Codable {
  let partcolors: [String]
  let bgcolors: [String]
  let parts: [[Trait]]
}

/// The Noun's trait.
struct Trait: Codable {
  
  /// `RLE` data compression of the Noun's trait.
  let data: String
  
  /// Asset image of the Noun's trait stored locally.
  let name: String
  
  /// Various animations for the related trait.
  let textures: [String: [String]]
  
  private enum CodingKeys: String, CodingKey {
    case data
    case name
    case textures
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    data = try container.decode(String.self, forKey: .data)
    name = try container.decode(String.self, forKey: .name)
    
    guard let headToMouthTexture = decoder.userInfo[.headToMouthTexture] as? [String: [String]], let mouthTexture = headToMouthTexture[name] else {
      textures = [:]
      return
    }
    
    textures = ["mouth": mouthTexture]
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(data, forKey: .data)
    try container.encode(textures, forKey: .textures)
  }
}

public struct NounsTextureGenerator: ParsableCommand {
  
  @Option var inputFile: String
  
  public init() { }
  
  public func run() throws {
    let inputFileURL = URL(fileURLWithPath: inputFile)
    let dataFrame = try loadCSV(at: inputFileURL)
    
    // Convert the loaded CSV file to json.
    var headToMouthTexture = [String: [String]]()
    
    // Iterate through the CSV data & build the head to mouth structure.
    let fileExtension = "png"
    
    for row in dataFrame.rows {
      guard let head = row["head", String.self]?.delete(fileExtension),
            let mouth1 = row["mouth-1", String.self]?.delete(fileExtension),
            let mouth2 = row["mouth-2", String.self]?.delete(fileExtension),
            let mouth3 = row["mouth-3", String.self]?.delete(fileExtension),
            let mouth4 = row["mouth-4", String.self]?.delete(fileExtension)
      else {
        fatalError("💥 Couldn't parse mouth texture of \(row)")
      }
      
      headToMouthTexture[head] = [mouth1, mouth2, mouth3, mouth4]
    }
      
    // Alter the noun layers data to introduce the animation.
    let layers = try loadNounsLayers(userInfo: headToMouthTexture)
    
    var outputFileURL = inputFileURL.deletingLastPathComponent()
    outputFileURL.appendPathComponent("nouns-traits-layers.json")
    
    let decodedData = try JSONEncoder().encode(layers)
    try decodedData.write(to: outputFileURL)
  }
  
  private func loadNounsLayers(userInfo: [String: [String]]) throws -> Layer {
    let filename = "nouns-traits-layers"
    let fileExtension = "json"
    
    guard let url = Bundle.module.url(
      forResource: filename,
      withExtension: fileExtension
    ) else {
      throw RuntimeError("🛑 File \(filename) not found!")
    }
    
    let jsonDecoder = JSONDecoder()
    jsonDecoder.userInfo = [.headToMouthTexture: userInfo]
    
    let data = try Data(contentsOf: url)
    return try jsonDecoder.decode(Layer.self, from: data)
  }
  
  // MARK: - CSV
  
  private func loadCSV(at url: URL) throws -> DataFrame {
    let readingOptions = CSVReadingOptions(
      hasHeaderRow: true,
      ignoresEmptyLines: true,
      delimiter: ";"
    )
    
    return try DataFrame(
      contentsOfCSVFile: url,
      options: readingOptions
    )
  }
}

extension CodingUserInfoKey {
    static let headToMouthTexture = CodingUserInfoKey(rawValue: "HeadToMouthTexture")!
}
