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

import Combine
import Services
import NounsUI

final class AppCore {
  static let shared = AppCore()
  
  let crashReporting: CrashReporting = Crashlytics()
  let analytics: Analytics = FirebaseAnalytics()
  
  let onChainNounsService: OnChainNounsService = TheGraphOnChainNouns()
  let offChainNounsService: OffChainNounsService = CoreDataOffChainNouns()
  let nounComposer: NounComposer = OfflineNounComposer.default()

  /// A service to extract the eth domain from the network.
  let ensNameService: ENS = Web3ENSProvider()
  
  /// Service responsible for handling Apple Push Notifications.
  let messaging: Messaging = FirebaseMessaging()
  
  /// User stored preference settings.
  lazy var settingsStore: SettingsStore = UserDefaultsSettingsStore(messaging: messaging)
  
}
