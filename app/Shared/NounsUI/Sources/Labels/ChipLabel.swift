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

import SwiftUI

/// A label for user interface items, consisting of
/// an no sign icon with a title.
public struct ChipLabel: View {
  /// Various label's states.
  public enum State: String {
    case pending
    case active
    case cancelled
    case vetoed
    case queued
    case executed
    case expired
    
    /// States that follow a proposal that has not yet progressed past quorum
    case defeated
    case succeeded
  }
  
  private let title: String
  private let state: State
  
  /// A standard label for user interface items, consisting
  /// of an icon with a title for a given state.
  ///
  ///  ```
  ///   ChipLabel("Voted for", state: .positive)
  ///   ChipLabel("Voted against", state: .neutral)
  ///   ChipLabel("Absent for", state: .negative)
  ///   ``
  public init(_ title: String, state: State) {
    self.title = title
    self.state = state
  }
  
  public var body: some View {
    HStack {
      state.image
      Text(title)
        .font(.custom(.medium, relativeTo: .caption))
      
    }
    .foregroundColor(state.foregroundColor)
    .contained(textColor: .white, backgroundColor: state.backgroundColor)
  }
}

extension ChipLabel.State {
  
  fileprivate var image: Image {
    switch self {
    case .pending:
      return .pending
    case .active:
      return .active
    case .cancelled:
      return .absent
    case .vetoed:
      return .cancel
    case .queued:
      return .queued
    case .executed:
      return .check
    case .defeated:
      return .xmark
    case .succeeded:
      return .check
    case .expired:
      return .queued
    }
  }
  
  fileprivate var foregroundColor: Color {
    switch self {
    case .queued, .expired:
      return .componentNounsBlack.opacity(0.5)
    default:
      return .white
    }
  }
  
  fileprivate var backgroundColor: Color {
    switch self {
    case .pending:
      return .blue
    case .active:
      return .componentNounsBlack
    case .cancelled:
      return .componentNounsBlack.opacity(0.7)
    case .vetoed:
      return .componentSoftCherry
    case .queued:
      return .componentNounsBlack.opacity(0.22)
    case .executed:
      return .green
    case .defeated:
      return .componentSoftCherry
    case .succeeded:
      return .green
    case .expired:
      return .componentNounsBlack.opacity(0.22)
    }
  }
}
