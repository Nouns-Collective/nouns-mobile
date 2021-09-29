//
//  NounsApp.swift
//  NounsWatch WatchKit Extension
//
//  Created by Mohammed Ibrahim on 2021-09-29.
//

import SwiftUI

@main
struct NounsApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
