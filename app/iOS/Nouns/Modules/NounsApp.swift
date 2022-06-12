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

import SwiftUI
import NounsUI
import Services
import WidgetKit

struct NounComposerKey: EnvironmentKey {
  static var defaultValue: NounComposer = AppCore.shared.nounComposer
}

extension EnvironmentValues {
  
  // TODO: clean up environment values
  var nounComposer: NounComposer {
    get { self[NounComposerKey.self] }
    set { self[NounComposerKey.self] = newValue }
  }
}

@main
struct NounsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  private let nounComposer: NounComposer
  private let bottomSheetManager = BottomSheetManager()
  
  init() {
    BackgroundNotifications.configure()
    nounComposer = AppCore.shared.nounComposer
    NounsUI.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      RouterView()
        .environmentObject(bottomSheetManager)
        .environment(\.nounComposer, nounComposer)
        .preferredColorScheme(.light)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {

    application.registerForRemoteNotifications()
    return true
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    // Request to update all widgets contents.
    WidgetCenter.shared.reloadAllTimelines()
    
    AppCore.shared.messaging.appDidReceiveNotification(userInfo)
    completionHandler(.newData)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    AppCore.shared.messaging.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    Task {
      await BackgroundNotifications.subscribe()
    }
  }
}
