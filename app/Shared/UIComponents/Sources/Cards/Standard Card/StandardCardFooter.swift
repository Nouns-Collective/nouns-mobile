//
//  StandardCardFooter.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-10-29.
//

import SwiftUI

internal struct StandardCardFooter: View {
    
    /// The header text, located on the top left of the footer
    let header: String
    
    /// The subheader text, located on the bottom left of the footer (beneath the header)
    let subheader: String
    
    /// The detail text, located on the top right of the footer
    let detail: String
    
    /// The detail's subheader, located on the bottom right of the footer
    let detailSubheader: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(header)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(subheader)
                    .font(.caption)
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(detail)
                    .fontWeight(.medium)
                
                Text(detailSubheader)
                    .font(.caption)
            }
        }
    }
}
