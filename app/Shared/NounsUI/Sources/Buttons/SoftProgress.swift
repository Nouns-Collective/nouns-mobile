//
//  SwiftUIView.swift
//  
//
//  Created by Ziad Tamim on 07.02.22.
//

import SwiftUI

public struct GradientProgressStyle: ProgressViewStyle {
  /// A gradient showing the fraction completed by the progress view.
  private let gradient: Gradient
  
  public init(_ gradient: Gradient) {
    self.gradient = gradient
  }
  
  public func makeBody(configuration: Configuration) -> some View {
    let fractionComplete = configuration.fractionCompleted ?? 0
    
    ZStack {
      GeometryReader { proxy in
        Gradient.bubbleGum
          .cornerRadius(8)
          .frame(width: fractionComplete * proxy.size.width)
      }
    }
  }
}

public struct SoftProgress: View {
  
  /// The completed fraction of the task represented by the progress view,
  /// from 0.0 (not yet started) to 1.0 (fully complete), or nil if the progress is indeterminate.
  public let value: Double?
  
  /// A label describing the task represented by the progress view.
  public let text: String
  
  public init(value: Double?, text: String) {
    self.value = value
    self.text = text
  }
  
  public var body: some View {
    SoftButton(label: {
      HStack {
        Text(text)
          .font(Font.body.weight(.medium))
        
        Spacer()
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
      
    }, action: { })
      .controlSize(.large)
      .background(
        ProgressView(value: value)
          .progressViewStyle(GradientProgressStyle(.bubbleGum))
      )
  }
}

struct SoftProgress_Previews: PreviewProvider {
  
  init() {
    NounsUI.configure()
  }
  
  static var previews: some View {
    SoftProgress(value: 0.7, text: "Preparing video...")
      .padding(.horizontal, 20)
  }
}
