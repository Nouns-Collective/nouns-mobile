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

  /// Optional URL metadata that can be sent along with a message using titleMetadata
  let urlMetadata: URL?
  
  public init(
    activityItems: [Any],
    applicationActivities: [UIActivity]? = nil,
    excludedActivityTypes: [UIActivity.ActivityType]? = nil,
    imageMetadata: UIImage? = nil,
    titleMetadata: String? = nil,
    urlMetadata: URL? = nil,
    callback: Callback? = nil
  ) {
    self.imageMetadata = imageMetadata
    self.titleMetadata = titleMetadata
    self.urlMetadata = urlMetadata
    self.activityItems = activityItems
    self.applicationActivities = applicationActivities
    self.excludedActivityTypes = excludedActivityTypes
    self.callback = callback
  }
  
  public func makeUIViewController(context: Context) -> UIActivityViewController {
    var activityItems = activityItems

    if let titleMetadata = titleMetadata {
      if let imageMetadata = imageMetadata {
        let imageItem = ShareActivityImageSource(image: imageMetadata, title: titleMetadata)
        activityItems.append(imageItem)
      }

      if let urlMetaData = urlMetadata {
        let urlItem = ShareActivityURLSource(url: urlMetaData, message: titleMetadata)
        activityItems.append(urlItem)
      }

      let messageItem = ShareActivityTextSource(titleMetadata)
      activityItems.append(messageItem)
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

internal class ShareActivityImageSource: NSObject, UIActivityItemSource {

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
    return title
  }

  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return image
  }

  func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType: UIActivity.ActivityType?) -> String {
    return title
  }

  func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
    let linkMetaData = LPLinkMetadata()
    linkMetaData.imageProvider = NSItemProvider(object: image)
    linkMetaData.title = title
    
    // Temporarily save image locally to retrieve file size and metadata
    // Create a URL in the /tmp directory
    let filename = UUID().uuidString
    var imageURL = URL(fileURLWithPath: NSTemporaryDirectory())
    imageURL.appendPathComponent(filename)
    imageURL.appendPathExtension("jpeg")

    guard let jpgData = image.jpegData(compressionQuality: 1.0) else {
      print("🛑 Could not get jpgData from image: \(image)")
      return linkMetaData
    }
    
    do {
      try jpgData.write(to: imageURL)
    } catch {
      print("🛑 Could not create a temporary file at the directory: \(imageURL.absoluteString)")
    }

    // Subtitle with file size
    let prefix = "JPEG Image"

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

internal class ShareActivityTextSource: NSObject, UIActivityItemSource {

  internal let message: String

  init(_ message: String) {
    self.message = message
  }

  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return message
  }

  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    switch activityType {

    case UIActivity.ActivityType.mail:
      return nil

    default:
      return message
    }
  }
}

internal class ShareActivityURLSource: ShareActivityTextSource {

  private let url: URL

  init(url: URL, message: String) {
    self.url = url
    super.init(message)
  }

  override func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return url
  }

  override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return url
  }

  func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType: UIActivity.ActivityType?) -> String {
    return message
  }
}
