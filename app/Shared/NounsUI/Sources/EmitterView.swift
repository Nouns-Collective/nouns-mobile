// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI

public struct EmitterView: UIViewRepresentable {
    
    public init() {}
    
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterCells = createEmitterCells()
        
        let rect = UIScreen.main.bounds.size
        emitterLayer.emitterSize = CGSize(width: rect.width, height: 1)
        emitterLayer.position = CGPoint(x: rect.width / 2, y: 0)
        view.layer.addSublayer(emitterLayer)
        
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) { }
    
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
