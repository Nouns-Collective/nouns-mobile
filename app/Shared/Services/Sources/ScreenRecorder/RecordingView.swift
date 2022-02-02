//
//  RecordingView.swift
//  
//
//  Created by Mohammed Ibrahim on 2022-01-29.
//

import UIKit

/// A wrapper for the view to record using the `ScreenRecorder`
///
/// The `RecordingView` can hold an instance of a main view (`sourceView`) and an optional
/// background view (`backgroundView`). The two views are layered together and presented as one view
/// to record frame-by-frame. Each frame is flattened into an image with the background in the
/// back of the frame and the source view on top.
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
