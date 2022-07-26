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
