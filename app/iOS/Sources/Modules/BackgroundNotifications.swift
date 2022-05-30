//
//  BackgroundNotifications.swift
//  Nouns
//
//  Created by Krishna Satyanarayana on 2022-04-19.
//

import Firebase

public struct BackgroundNotifications {

  private static let backgroundNotificationsTopic = "background_auction_did_start"

  public static func configure() {
    FirebaseApp.configure()
  }

  public static func subscribe() async {
    do {
      try await AppCore.shared.messaging.subscribe(toTopic: Self.backgroundNotificationsTopic)
    } catch {
      AppCore.shared.crashReporting.record(error: error)
    }
  }
}
