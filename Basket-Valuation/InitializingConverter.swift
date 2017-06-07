//
//  InitializingConverter.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 05.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import Foundation

class InitializingConverter : CurrencyConverter {
    let errorDescription = ""
    func convert(usd: Double, to currency: String) -> Double? {
        return nil
    }
    func format(usd: Double, as currency: String) -> String {
        return "initializing rates"
    }
    func rateString(for currency:String) -> String {
        return "Initializing rates"
    }
    var conversionRates: [String : Double] { get { return ["none": 0.0] } }
}
