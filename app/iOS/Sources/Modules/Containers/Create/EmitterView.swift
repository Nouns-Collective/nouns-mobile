//
//  EmitterView.swift
//  Nouns
//
//  Created by Ziad Tamim on 29.11.21.
//

import SwiftUI

struct EmitterView: UIViewRepresentable {
  
  func makeUIView(context: Context) -> some UIView {
    let view = UIView()
    view.backgroundColor = .clear
    
    let emitterLayer = CAEmitterLayer()
    emitterLayer.emitterShape = .line
    emitterLayer.emitterCells = createEmitterCells()
    
    let rect = UIScreen.main.bounds.size
    emitterLayer.emitterSize = CGSize(width: rect.width, height: 1)
    emitterLayer.position = CGPoint(x: rect.width/2, y: 0)
    view.layer.addSublayer(emitterLayer)
    
    return view
  }
  
  func updateUIView(_ uiView: UIViewType, context: Context) {
    
  }
  
  private func createEmitterCells() -> [CAEmitterCell] {
    var cells = [CAEmitterCell]()
    for index in 1...10 {
      let cell = CAEmitterCell()
      cell.contents = UIImage(named: "confetti-\(index)")?.cgImage
      cell.birthRate = 8
      cell.lifetime = 20
      cell.velocity = 120
      cell.scale = 0.2
      cell.scaleRange = 0.8
      cell.emissionLongitude = .pi
      cell.emissionRange = 0.5
      cell.spin = 3.5
      cell.spinRange = 1
      cell.yAcceleration = 300
      cell.zAcceleration = 300
      cells.append(cell)
    }
    
    return cells
  }
}
