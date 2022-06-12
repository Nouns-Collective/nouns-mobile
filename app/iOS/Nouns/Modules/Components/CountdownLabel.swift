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

/// A label that displays the remaining time from `now` and a user-set `endTime` and updates
/// every second, to keep the remaining time up to date
struct CountdownLabel: View {

  /// The end time that this label should be counting down to
  let endTime: TimeInterval
  
  /// Calculates the time left starting from now and ending at the `endTime`
  private var timeLeft: DateComponents {
    Calendar.current.dateComponents(
      [.hour, .minute, .second],
      from: .now,
      to: Date(timeIntervalSince1970: endTime)
    )
  }
  
  /// Formats the time left in a standard time format *00h:00m:00s*
  private static func formatTimeLeft(_ components: DateComponents) -> String? {
    guard let hour = components.hour,
          let minute = components.minute,
          let second = components.second
    else { return nil }
    
    return R.string.liveAuction.timeLeft(hour, minute, second)
  }
  
  var body: some View {
    TimelineView(.periodic(from: .now, by: 1)) { _ in
      let timeLeft = Self.formatTimeLeft(timeLeft)
      let remainingTime = timeLeft ?? R.string.shared.notApplicable()
      
      Text(remainingTime)
    }
  }
}
