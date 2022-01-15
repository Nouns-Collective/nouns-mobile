//
//  ShareSheet.swift
//  
//
//  Created by Ziad Tamim on 03.12.21.
//

import SwiftUI
import LinkPresentation

public struct ShareSheet: UIViewControllerRepresentable {
  public typealias Callback = (
    _ activityType: UIActivity.ActivityType?,
    _ completed: Bool,
    _ returnedItems: [Any]?,
    _ error: Error?
  ) -> Void
  
  let activityItems: [Any]
  let applicationActivities: [UIActivity]?
  let excludedActivityTypes: [UIActivity.ActivityType]?
  let callback: Callback?
  
  /// Optional image metadata to manually set the icon preview of the share sheet
  /// When added, the file size of the image will be shown as well in the subtitle
  let imageMetadata: UIImage?
  
  /// Optional text metadata to manually set the title of the share sheet
  let titleMetadata: String?
  
  public init(
    activityItems: [Any],
    applicationActivities: [UIActivity]? = nil,
    excludedActivityTypes: [UIActivity.ActivityType]? = nil,
    imageMetadata: UIImage? = nil,
    titleMetadata: String? = nil,
    callback: Callback? = nil
  ) {
    self.imageMetadata = imageMetadata
    self.titleMetadata = titleMetadata
    self.activityItems = activityItems
    self.applicationActivities = applicationActivities
    self.excludedActivityTypes = excludedActivityTypes
    self.callback = callback
  }
  
  public func makeUIViewController(context: Context) -> UIActivityViewController {
    var activityItems = activityItems
    
    if let imageMetadata = imageMetadata, let titleMetadata = titleMetadata {
      let itemSource = ShareActivityMetadataSource(image: imageMetadata, title: titleMetadata)
      activityItems.append(itemSource)
    }
    
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )
    controller.excludedActivityTypes = excludedActivityTypes
    controller.completionWithItemsHandler = callback
    return controller
  }
  
  public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
  
}

internal class ShareActivityMetadataSource: NSObject, UIActivityItemSource {

  /// The preview icon to show in the share sheet
  private var image: UIImage
  
  /// The preview title to show in the share sheet
  private var title: String

  init(image: UIImage, title: String) {
    self.image = image
    self.title = title
    super.init()
  }

  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return String()
  }

  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return nil
  }

  func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
    let linkMetaData = LPLinkMetadata()
    linkMetaData.imageProvider = NSItemProvider(object: image)
    linkMetaData.title = title
    
    // Temporarily save image locally to retrieve file size and metadata
    // Create a URL in the /tmp directory
    guard let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(title).png") else {
        return linkMetaData
    }

    let pngData = image.pngData()
    try? pngData?.write(to: imageURL)

    // Subtitle with file size
    let prefix = "PNG Image"

    let fileSizeResourceValue = try? imageURL.resourceValues(forKeys: [.fileSizeKey])
    
    guard let fileSizeResourceValue = fileSizeResourceValue, let fileSizeInt = fileSizeResourceValue.fileSize else {
      return linkMetaData
    }
    
    // Fetch file size of image and convert to readable string
    let byteCountFormatter = ByteCountFormatter()
    byteCountFormatter.countStyle = .file
    let fileSizeString = byteCountFormatter.string(fromByteCount: Int64(fileSizeInt))

    let suffix = "・\(fileSizeString)"
    
    // The fileURLWithPath in originalURL acts as the subtitle
    linkMetaData.originalURL = URL(fileURLWithPath: "\(prefix)\(suffix)")
    
    return linkMetaData
  }
}
