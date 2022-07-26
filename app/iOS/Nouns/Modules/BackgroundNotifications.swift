// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Krishna Satyanarayana
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
