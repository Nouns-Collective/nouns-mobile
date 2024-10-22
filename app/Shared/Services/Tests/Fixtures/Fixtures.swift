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
@testable import Services

final class Fixtures {
    
    static func data(contentOf filename: String, withExtension ext: String) -> Data? {
        guard let url = Bundle.module.url(forResource: filename, withExtension: ext),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return data
    }
}
