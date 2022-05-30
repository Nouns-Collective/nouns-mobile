//
//  NotificationService.swift
//  OclockRichNotification
//
//  Created by Ziad Tamim on 21.04.22.
//

import UserNotifications
import UniformTypeIdentifiers
import os

class NotificationService: UNNotificationServiceExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  
  /// An object for writing interpolated string messages to the unified logging system.
  private let logger = Logger(
    subsystem: "wtf.nouns.ios.OclockRichNotification",
    category: "NotificationService"
  )
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
    
    guard let bestAttemptContent = bestAttemptContent else { return }
    
    guard let todaysNounString = bestAttemptContent.userInfo["todays_noun_img"] as? String,
          let todaysNounURL = URL(string: todaysNounString)
    else {
      return contentHandler(bestAttemptContent)
    }
    
    Task {
      do {
        let attachmentURL = try await URLSession.shared.download(from: todaysNounURL).0
        let attachmentOptions = [UNNotificationAttachmentOptionsTypeHintKey: UTType.png.identifier]
        let attachment = try UNNotificationAttachment(
          identifier: todaysNounString,
          url: attachmentURL,
          options: attachmentOptions)
        
        bestAttemptContent.attachments = [attachment]
        contentHandler(bestAttemptContent)
        
      } catch {
        logger.error("💥 Unable to download today's Noun from notification content: \(error.localizedDescription, privacy: .public)")
        
        contentHandler(bestAttemptContent)
      }
    }
  }
  
  override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
      contentHandler(bestAttemptContent)
    }
  }
  
}
