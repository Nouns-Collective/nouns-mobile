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

import SwiftUI

/// Markdown parser to extract all elements.
internal class MarkdownParser {
    internal let content: String
    
    internal init(content: String) {
        self.content = content
    }
    
    internal lazy var title: String? = {
        guard let range = content.range(
            of: #"(^\s*#{1,6}\s+([^\n]+)|^\s*([^\n]+)\n(={3,25}|-{3,25}))"#,
            options: .regularExpression)
        else { return nil }
        
        return String(content[range]
                        .replacingOccurrences(
                            of: #"(^*#{1,6} *|\*\*|__|\n|\r|=*$)"#,
                            with: "",
                            options: .regularExpression))
    }()
}
