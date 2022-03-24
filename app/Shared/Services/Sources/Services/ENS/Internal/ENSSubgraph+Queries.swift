//
//  ENS+Queries.swift
//  
//
//  Created by Ziad Tamim on 12.11.21.
//

import Foundation

internal enum ENSSubgraph {
    
    internal struct DomainLookupQuery: GraphQLQuery {
        internal let url = CloudConfiguration.ENS.query.url
        internal let token: String
        
        var operationDefinition: String {
         """
           {
            domains(where: { resolvedAddress: "\(token)" }) {
               id
               name
             }
           }
         """
        }
    }
}