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

/// A formatter that converts between different Ether units, such as wei and eth.
public class EtherFormatter: Formatter {
    
    static let ethToWeiFactor: NSDecimalNumber = 1_000_000_000_000_000_000
    
    public enum Unit {
        case wei
        case eth
    }
    
    /// The ether unit we are converting from
    private let fromUnit: Unit
    
    /// The ether unit we are converting to (defaults to eth)
    public var unit: Unit = .eth
    
    /// The minimum number of digits after the decimal point
    public var minimumFractionDigits: Int = 2

    /// The maximum number of digits after the decimal point
    public var maximumFractionDigits: Int = 2
    
    public init(from fromUnit: Unit) {
        self.fromUnit = fromUnit
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Converts values between different units
    private func convert(_ value: NSDecimalNumber) -> NSDecimalNumber {
        switch (fromUnit, unit) {
        /// Converting from WEI to ETH
        case (.wei, .eth):
            return value.dividing(by: EtherFormatter.ethToWeiFactor)
        /// Converting from ETH to WEI
        case (.eth, .wei):
            return value.multiplying(by: EtherFormatter.ethToWeiFactor)
        default:
            return value
        }
    }
    
    /// Converts and returns an ether unit to another unit
    ///
    ///
    /// - Parameters:
    ///   - stringVal: The string literal of the integer value we are converting. All characters must be digits.
    ///
    /// - Returns: A string literal of the converted integer value.
    public func string(from stringVal: String) -> String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        guard let number = formatter.number(from: stringVal) as? NSDecimalNumber else {
            return nil
        }
        
        let value = convert(number)
        return formatter.string(from: value)
    }
}
