//
//  Markdown+Parser.swift
//  
//
//  Created by Ziad Tamim on 13.11.21.
//

import Foundation

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

