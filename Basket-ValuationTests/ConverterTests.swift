//
//  ConverterTests.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 04.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import XCTest
@testable import Basket_Valuation

class ConverterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMockConverter() {
        let converter = MockConverter()
        XCTAssertEqual(1.0, converter.convert(usd: 1.0, to: "USD"))
        XCTAssertEqualWithAccuracy(9.99, converter.convert(usd: 11.1, to: "EUR")!, accuracy: 0.005)
        XCTAssertEqualWithAccuracy(99.0, converter.convert(usd: 100, to: "CHF")!, accuracy: 0.005)
        XCTAssertNil(converter.convert(usd: 23, to:"DKK"))
    }
    
    let demo = "{\"success\":true,\"terms\":\"https:\\/\\/currencylayer.com\\/terms\",\"privacy\":\"https:\\/\\/currencylayer.com\\/privacy\",\"timestamp\":1496593778,\"source\":\"USD\",\"quotes\":{\"USDUSD\":1,\"USDEUR\":0.886304,\"USDCHF\":0.96251,\"USDDKK\":6.594131}}"

    func testJsonConverter() {
        let converter = JSONCurrencyConverter(string:demo)
        XCTAssertEqual(1.0, converter.convert(usd: 1.0, to: "USD"))
        XCTAssertEqualWithAccuracy(9.84, converter.convert(usd: 11.1, to: "EUR")!, accuracy: 0.005)
        XCTAssertEqualWithAccuracy(96.25, converter.convert(usd: 100, to: "CHF")!, accuracy: 0.005)
        XCTAssertEqualWithAccuracy(151.67, converter.convert(usd: 23, to: "DKK")!, accuracy: 0.005)
        XCTAssertNil(converter.convert(usd: 37, to:"NOK"))
        XCTAssertEqual("98.38 EUR", converter.format(usd: 111, as:"EUR"))
        XCTAssertEqual("missing rate for NOK", converter.rateString(for: "NOK"))
        XCTAssertEqual("conversion impossible", converter.format(usd: 111, as:"NOK"))
        XCTAssertEqual(["CHF", "DKK", "EUR", "USD"], converter.availableCurrencies)
    }
    
    func testMissingSuccess() {
        let converter = JSONCurrencyConverter(string:"{\"sucess\":true,\"quotes\":{\"USDUSD\":1,\"USDEUR\":0.886304,\"USDCHF\":0.96251,\"USDDKK\":6.594131}}")
        XCTAssertNil(converter.convert(usd: 10, to: "USD"))
        XCTAssertEqual("success missing or not Bool", converter.rateString(for: "DKK"))
        XCTAssertEqual("conversion impossible", converter.format(usd: 10, as: "DKK"))
    }
    
    func testMissingQuotes() {
        let converter = JSONCurrencyConverter(string:"{\"success\":true,\"qutes\":{\"USDUSD\":1,\"USDEUR\":0.886304,\"USDCHF\":0.96251,\"USDDKK\":6.594131}}")
        XCTAssertNil(converter.convert(usd: 10, to: "USD"))
        XCTAssertEqual("quotes missing or not [String:Double]", converter.rateString(for: "DKK"))
        XCTAssertEqual("conversion impossible", converter.format(usd: 10, as: "DKK"))
    }
    
    func testUnsuccessfulJson() {
        let converter = JSONCurrencyConverter(string:"{\"success\":false,\"quotes\":{\"USDUSD\":1,\"USDEUR\":0.886304,\"USDCHF\":0.96251,\"USDDKK\":6.594131}}")
        XCTAssertNil(converter.convert(usd: 10, to: "USD"))
        XCTAssertEqual("data request not successful", converter.rateString(for: "DKK"))
        XCTAssertEqual("conversion impossible", converter.format(usd: 10, as: "DKK"))
    }
    
    func testUnparseableGarbage() {
        let converter = JSONCurrencyConverter(string: "{Hi I am 42")
        XCTAssertNil(converter.convert(usd: 10, to: "USD"))
        XCTAssertEqual("The data couldn’t be read because it isn’t in the correct format.", converter.rateString(for: "DKK"))
        XCTAssertEqual("conversion impossible", converter.format(usd: 10, as: "DKK"))
    }
    
    func testFormattedConversion() {
        let converter = MockConverter()
        XCTAssertEqual("99.90 EUR", converter.format(usd: 111, as:"EUR"))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
