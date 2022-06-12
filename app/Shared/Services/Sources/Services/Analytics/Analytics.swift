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

import Foundation
import Firebase
import FirebaseAnalytics

public protocol Analytics {
  
  /// Logs an app event. The event can have up to 25 parameters. Events with the same name must have
  /// the same parameters.
  ///
  /// - Parameters:
  ///   - name: The name of the event. Should contain 1 to 40 alphanumeric characters or underscores.
  ///   - parameters: The dictionary of event parameters. Passing nil indicates that the event has
  ///     no parameters. Parameter names can be up to 40 characters long and must start with an
  ///     alphabetic character and contain only alphanumeric characters and underscores.
  ///
  func logEvent(withName name: String, parameters: [String: Any]?)

  /// Logs an app event given a predefined Event enum value.
  ///
  /// - Parameters:
  ///   - event: The event enum value.
  ///   - parameters: The dictionary of event parameters. Passing nil indicates that the event has
  ///     no parameters. Parameter names can be up to 40 characters long and must start with an
  ///     alphabetic character and contain only alphanumeric characters and underscores.
  ///
  func logEvent(withEvent event: AnalyticsEvent.Event, parameters: [String: Any]?)

  /// Logs a screen transition to track user engagement on various screens throughout the app.
  ///
  /// - Parameters:
  ///   - screen: The screen enum value for the screen that is being transitioned to.
  ///
  func logScreenView(withScreen screen: AnalyticsEvent.Screen)
  
  /// Sets a user property to a given value. Up to 25 user property names are supported. Once set,
  /// user property values persist throughout the app lifecycle and across sessions.
  ///
  /// - Parameters:
  ///   - value: The value of the user property. Values can be up to 36 characters long. Setting the
  ///     value to nil removes the user property.
  ///   - name: The name of the user property to set. Should contain 1 to 24 alphanumeric characters
  ///     or underscores and must start with an alphabetic character.
  func setUserPropertyString(_ value: String?, forName name: String)
}

public class FirebaseAnalytics: Analytics {
  
  public init() {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
  }

  public func logEvent(withEvent event: AnalyticsEvent.Event, parameters: [String: Any]?) {
    logEvent(withName: event.rawValue, parameters: parameters)
  }

  public func logEvent(withName name: String, parameters: [String: Any]?) {
    Firebase.Analytics.logEvent(name, parameters: parameters)
  }

  public func logScreenView(withScreen screen: AnalyticsEvent.Screen) {
    Firebase.Analytics.logEvent(AnalyticsEventScreenView,
                                parameters: [AnalyticsParameterScreenName: screen.rawValue,
                                            AnalyticsParameterScreenClass: screen.rawValue])
  }
  
  public func setUserPropertyString(_ value: String?, forName name: String) {
    Firebase.Analytics.setUserProperty(value, forName: name)
  }
}
