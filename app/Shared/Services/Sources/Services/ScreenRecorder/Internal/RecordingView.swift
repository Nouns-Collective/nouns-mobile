// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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

import UIKit

/// A wrapper for the view to record using the `ScreenRecorder`
///
/// The `RecordingView` can hold an instance of a main view (`sourceView`) and an optional
/// background view (`backgroundView`). The two views are layered together and presented as one view
/// to record frame-by-frame. Each frame is flattened into an image with the background in the
/// back of the frame and the source view on top.
internal class RecordingView: UIView {
  
  private var sourceView: UIView
  
  private var backgroundView: UIView?
  
  private var watermarkImageView: UIImageView = UIImageView()
  
  public var watermark: UIImage? {
    get { watermarkImageView.image }
    set { watermarkImageView.image = newValue }
  }
  
  private var frameSize: CGSize
  
  init(sourceView: UIView, backgroundView: UIView?) {
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
    
    // Add background if provided
    if let backgroundView = backgroundView {
      addSubview(backgroundView)

      backgroundView.frame = CGRect(origin: .zero, size: intrinsicContentSize)
      backgroundView.addSubview(sourceView)
    } else {
      addSubview(sourceView)
    }
    
    sourceView.frame = CGRect(origin: .zero, size: intrinsicContentSize)
    
    // Add watermark image view above all other content
    addSubview(watermarkImageView)
    watermarkImageView.translatesAutoresizingMaskIntoConstraints = false
    watermarkImageView.contentMode = .scaleAspectFit
    
    NSLayoutConstraint.activate([
      watermarkImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
      watermarkImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
      watermarkImageView.heightAnchor.constraint(equalToConstant: 44),
      watermarkImageView.widthAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  func setWatermarkDisplay(hidden: Bool) {
    watermarkImageView.isHidden = hidden
  }
  
  override var intrinsicContentSize: CGSize {
    self.frameSize
  }
}
