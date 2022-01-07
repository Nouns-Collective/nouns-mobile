//
//  AnalyticsService.swift
//  
//
//  Created by Ziad Tamim on 03.01.22.
//

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

public class FirebaseAnalyticsProvider: Analytics {
  
  public init() {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
  }
  
  public func logEvent(withName name: String, parameters: [String : Any]?) {
    FirebaseAnalytics.Analytics.logEvent(name, parameters: parameters)
  }
  
  public func setUserPropertyString(_ value: String?, forName name: String) {
    FirebaseAnalytics.Analytics.setUserProperty(value, forName: name)
  }
}
