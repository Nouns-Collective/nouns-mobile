//
//  CrashReporting.swift
//  
//
//  Created by Ziad Tamim on 03.01.22.
//

import Firebase
import FirebaseCrashlytics

public protocol CrashReporting {
  
  /// Records a non-fatal event described by an NSError object. The events are
  /// grouped and displayed similarly to crashes.
  ///
  ///  - Parameters:
  ///   - error: Non-fatal error to be recorded
  func record(error: Error)
}

public class Crashlytics: CrashReporting {
 
  public init() {
    if FirebaseApp.app() == nil {
      FirebaseApp.configure()
    }
  }
  
  public func record(error: Error) {
    Firebase.Crashlytics.crashlytics().record(error: error)
  }
}
