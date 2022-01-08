//
//  Web3Client.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-12-18.
//

import Foundation
import web3

public protocol ABI: ABIFunction {
    
    /// The name of the function
    var name: String { get set }
    
    /// The address of the contract this function/transaction is defined on
    var contract: String { get set }
    
    /// The from token address
    var from: String? { get set }
    
    /// The to token address
    var to: String { get set }
    
    /// The data to be passed along to the function
    var data: Data { get set }
    
    /// This is the amount in wei the sender is willing to pay for the transaction.
    var gasPrice: String? { get set }
    
    /// This is the maximum amount in wei that a transaction can use as gas.
    var gasLimit: String? { get set }
}

public enum EthereumError: Error {
    
    case badMainnetURL
}

public protocol Ethereum {
    
    func call(_ function: ABI) throws
}

public class Web3Client: Ethereum {
    /// The client layer provided by the `web3swift` package
    public let client: EthereumClient
    
    public init() throws {
        guard let url = CloudConfiguration.Infura.mainnet.url else {
            throw EthereumError.badMainnetURL
        }
        
        self.client = EthereumClient(url: url)
    }
    
    public func call(_ function: ABI) throws {
        //
    }
}
