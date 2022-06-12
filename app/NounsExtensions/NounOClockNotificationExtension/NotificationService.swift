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
