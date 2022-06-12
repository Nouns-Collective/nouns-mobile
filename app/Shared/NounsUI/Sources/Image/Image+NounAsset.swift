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

import Foundation
import SwiftUI
import UIKit

extension Image {
  
  /// This initializer creates an image using a Noun's trait-provided asset.
  ///
  /// - Parameters:
  ///   - nounTraitName: The name of the Noun's trait image.
  public init(nounTraitName: String) {
    self.init(nounTraitName, bundle: Bundle.module)
  }
}

extension UIImage {
  
  /// This initializer creates an image using a Noun's trait-provided asset.
  ///
  /// - Parameters:
  ///   - nounTraitName: The name of the Noun's trait image.
  public convenience init?(nounTraitName: String) {
    self.init(named: nounTraitName, in: .module, with: nil)
  }
}
