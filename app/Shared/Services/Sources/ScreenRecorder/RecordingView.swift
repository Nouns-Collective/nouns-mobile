//
//  RecordingView.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-29.
//

import UIKit

/// A view used to construct a custom view to record, with a custom main view and background view
internal class RecordingView: UIView {
  
  private var sourceView: UIView
  
  private var backgroundView: UIView
  
  private var frameSize: CGSize
  
  init(sourceView: UIView, backgroundView: UIView) {
    self.sourceView = sourceView
    self.backgroundView = backgroundView
    self.frameSize = sourceView.intrinsicContentSize
    
    super.init(frame: CGRect(origin: .zero, size: sourceView.intrinsicContentSize))
    
    setupContent()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupContent() {
    addSubview(backgroundView)

    backgroundView.frame = CGRect(origin: .zero, size: intrinsicContentSize)
    backgroundView.addSubview(sourceView)

    sourceView.frame = CGRect(origin: .zero, size: intrinsicContentSize)
  }
  
  override var intrinsicContentSize: CGSize {
    self.frameSize
  }
}
