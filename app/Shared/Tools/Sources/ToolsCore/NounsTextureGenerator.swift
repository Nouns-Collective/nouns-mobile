//
//  NounsTextureGenerator.swift
//  
//
//  Created by Ziad Tamim on 12.02.22.
//

/// This script is to be used to generate a json file describing all the traits and it's additional textures for animation purposes,
/// such a set of eye blinking frames to match a set of glasses or animated mouth frames to match a noun head.
///
/// It uses the

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
    
    guard let allTextures = decoder.userInfo[.textures] as? [String: [String: [String]]], let traitTextures = allTextures[name] else {
      textures = [:]
      return
    }
    
    textures = traitTextures
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
    var textures = [String: [String: [String]]]()
    
    // Iterate through the CSV data & build the head to mouth structure.
    let fileExtension = "png"
    
    // Head -> mouth
    for row in dataFrame.rows {
      guard let head = row["head", String.self]?.delete(fileExtension),
            let mouth1 = row["mouth-1", String.self]?.delete(fileExtension),
            let mouth2 = row["mouth-2", String.self]?.delete(fileExtension),
            let mouth3 = row["mouth-3", String.self]?.delete(fileExtension),
            let mouth4 = row["mouth-4", String.self]?.delete(fileExtension)
      else { continue }
      
      if textures[head] == nil {
        textures[head] = ["mouth": [mouth1, mouth2, mouth3, mouth4]]
      } else {
        textures[head]?["mouth"] = [mouth1, mouth2, mouth3, mouth4]
      }
    }
    
    // Glasses -> glasses-frame + eyes
    for row in dataFrame.rows {
      guard let glasses = row["glasses", String.self]?.delete(fileExtension),
            let glassesFrame = row["glasses-frame", String.self]?.delete(fileExtension),
            let eyesBlink1 = row["eyes-blink-1", String.self]?.delete(fileExtension),
            let eyesBlink2 = row["eyes-blink-2", String.self]?.delete(fileExtension),
            let eyesBlink3 = row["eyes-blink-3", String.self]?.delete(fileExtension),
            let eyesBlink4 = row["eyes-blink-4", String.self]?.delete(fileExtension),
            let eyesBlink5 = row["eyes-blink-5", String.self]?.delete(fileExtension),
            let eyesShift1 = row["eyes-shift-1", String.self]?.delete(fileExtension),
            let eyesShift2 = row["eyes-shift-2", String.self]?.delete(fileExtension),
            let eyesShift3 = row["eyes-shift-3", String.self]?.delete(fileExtension),
            let eyesShift4 = row["eyes-shift-4", String.self]?.delete(fileExtension),
            let eyesShift5 = row["eyes-shift-5", String.self]?.delete(fileExtension),
            let eyesShift6 = row["eyes-shift-6", String.self]?.delete(fileExtension)
      else { continue }
      
      if textures[glasses] == nil {
        textures[glasses] = [
          "glasses-frame": [glassesFrame],
          "eyes-blink": [eyesBlink1, eyesBlink2, eyesBlink3, eyesBlink4, eyesBlink5],
          "eyes-shift": [eyesShift1, eyesShift2, eyesShift3, eyesShift4, eyesShift5, eyesShift6]
        ]
      } else {
        textures[glasses]?["glasses-frame"] = [glassesFrame]
        textures[glasses]?["eyes-blink"] = [eyesBlink1, eyesBlink2, eyesBlink3, eyesBlink4, eyesBlink5]
        textures[glasses]?["eyes-shift"] = [eyesShift1, eyesShift2, eyesShift3, eyesShift4, eyesShift5, eyesShift6]
      }
    }
        
    // Alter the noun layers data to introduce the animation.
    let layers = try loadNounsLayers(userInfo: textures)
    
    var outputFileURL = inputFileURL.deletingLastPathComponent()
    outputFileURL.appendPathComponent("nouns-traits-layers.json")
    
    let decodedData = try JSONEncoder().encode(layers)
    try decodedData.write(to: outputFileURL)
  }
  
  private func loadNounsLayers(userInfo: [String: [String: [String]]]) throws -> Layer {
    let filename = "nouns-traits-layers"
    let fileExtension = "json"
    
    guard let url = Bundle.module.url(
      forResource: filename,
      withExtension: fileExtension
    ) else {
      throw RuntimeError("🛑 File \(filename) not found!")
    }
    
    let jsonDecoder = JSONDecoder()
    jsonDecoder.userInfo = [.textures: userInfo]
    
    let data = try Data(contentsOf: url)
    return try jsonDecoder.decode(Layer.self, from: data)
  }
  
  // MARK: - CSV
  
  private func loadCSV(at url: URL) throws -> DataFrame {
    let readingOptions = CSVReadingOptions(
      hasHeaderRow: true,
      ignoresEmptyLines: true,
      delimiter: ","
    )
    
    return try DataFrame(
      contentsOfCSVFile: url,
      options: readingOptions
    )
  }
}

extension CodingUserInfoKey {
    static let textures = CodingUserInfoKey(rawValue: "textures")!
}
