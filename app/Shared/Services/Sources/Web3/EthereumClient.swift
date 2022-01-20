//
//  Web3Client.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-18.
//

import Foundation
import web3

public enum EthereumError: Error {
    
    case badMainnetURL
}

public protocol Ethereum {}

public class Web3Client: Ethereum {
    /// The client layer provided by the `web3swift` package
    public let client: EthereumClient
    
    public init() throws {
        guard let url = CloudConfiguration.Infura.mainnet.url else {
            throw EthereumError.badMainnetURL
        }
        
        self.client = EthereumClient(url: url)
    }
}
