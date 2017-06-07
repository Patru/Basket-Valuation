//
//  ConversionRateProvider.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 04.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import UIKit

protocol CurrencyConverter {
    var conversionRates : [String:Double] { get }
    func convert(usd: Double, to currency: String) -> Double?
    func format(usd: Double, as currency: String) -> String
    var isReady : Bool { get }
    var errorDescription : String { get }
    var availableCurrencies : [String] { get }
    func rateString(for currency:String) -> String
}

extension CurrencyConverter {
    func convert(usd: Double, to currency: String) -> Double? {
        if let rate = conversionRates[currency] {
            return usd*rate
        }
        return nil
    }
    
    public func format(usd: Double, as currency: String) -> String {
        guard isReady, let converted = convert(usd:usd, to: currency)
            else {
                return "conversion impossible"
        }
        return String(format: "%.2f %@", converted, currency)
    }
    
    var isReady : Bool { get { return errorDescription.isEmpty } }
    var availableCurrencies : [String] { get { return conversionRates.keys.sorted() } }
    
    func rateString(for currency:String) -> String {
        guard isReady
            else {
                return errorDescription
        }
        if let rate = conversionRates[currency] {
            let intDigits = Int(log(rate)/log(10.0))
            let fracDigits : Int
            if intDigits > 0 {
                fracDigits = 5-intDigits
            } else {
                fracDigits = 5
            }
            let rateFormat = String(format: "Rate: %%.%df per $", fracDigits)
            return String(format: rateFormat, rate)
        } else {
            return String(format:"missing rate for %@", currency)
        }
    }
}
