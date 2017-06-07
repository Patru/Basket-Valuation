//
//  MockConverter.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 04.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//
@testable import Basket_Valuation

class MockConverter : CurrencyConverter {
    let conversionRates: [String:Double] = ["USD": 1.0, "EUR": 0.9, "CHF": 0.99, "YPN": 0.0088]
    var errorDescription : String { get { return "" } }
}
