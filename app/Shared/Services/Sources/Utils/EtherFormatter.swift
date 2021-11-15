//
//  EtherFormatter.swift
//  
//
//  Created by Mohammed Ibrahim on 2021-11-15.
//

import Foundation
import BigInt

/// A formatter that converts between different Ether units, such as wei and eth.
/// Since it deals with integers (through BigInt), all inputted and returned values must be integers as well.
public class EtherFormatter: Formatter {
    
    static let ethToWeiFactor = BigInt(stringLiteral: "1000000000000000000")
    
    public enum Unit {
        case wei
        case eth
    }
    
    /// The ether unit we are converting from
    private let fromUnit: Unit
    
    /// The ether unit we are converting to (defaults to eth)
    var unit: Unit = .eth
    
    public init(from fromUnit: Unit) {
        self.fromUnit = fromUnit
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Converts values between different units
    private func convert(_ value: BigInt) -> BigInt {
        switch (fromUnit, unit) {
        /// Converting from WEI to ETH
        case (.wei, .eth):
            return value / EtherFormatter.ethToWeiFactor
        /// Converting from ETH to WEI
        case (.eth, .wei):
            return value * EtherFormatter.ethToWeiFactor
        default:
            return BigInt(1)
        }
    }
    
    /// Converts and returns an ether unit to another unit
    ///
    ///
    /// - Parameters:
    ///   - stringVal: The string literal of the integer value we are converting. All characters must be digits.
    ///
    /// - Returns: A string literal of the converted integer value.
    func string(from stringVal: String) -> String? {
        guard let bigInt = BigInt(stringVal, radix: 10) else { return nil }
        let value = convert(bigInt)
        return String(value)
    }
    
    /// Converts and returns an ether unit to another unit
    ///
    ///
    /// - Parameters:
    ///   - bigInt: A BigInt representation of the value to convert
    ///
    /// - Returns: A string literal of the converted integer value.
    func string(from bigInt: BigInt) -> String {
        let value = convert(bigInt)
        return String(value)
    }
}
