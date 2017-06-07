//
//  BasketTests.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import XCTest
@testable import Basket_Valuation

class BasketTests: XCTestCase {
    var basket = Basket()
    
    override func setUp() {
        super.setUp()
        basket = Basket(peaBags:0, eggDozens: 0, milkBottles: 0, beanCans: 0)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCanStoreValues() {
        basket.peaBags = 3
        XCTAssertEqual(3, basket.peaBags)
        XCTAssertEqual(0, basket.milkBottles)
        basket.milkBottles = 10
        XCTAssertEqual(3, basket.peaBags)
        XCTAssertEqual(10, basket.milkBottles)
    }
    
    func testSummary() {
        XCTAssert(basket.empty)
        XCTAssertEqual("Your basket is empty", basket.summary)
        basket.beanCans = 2
        XCTAssertEqual("Your basket contains the following items:\n2 cans of beans", basket.summary)
        basket.milkBottles = 3
        XCTAssertEqual("Your basket contains the following items:\n3 bottles of milk\n2 cans of beans", basket.summary)
        basket.eggDozens = 4
        XCTAssertEqual("Your basket contains the following items:\n4 dozen eggs\n3 bottles of milk\n2 cans of beans", basket.summary)
        basket.peaBags = 5
        XCTAssertEqual("Your basket contains the following items:\n5 bags of peas\n4 dozen eggs\n3 bottles of milk\n2 cans of beans", basket.summary)
    }
    
    func testDollarValue() {
        basket.peaBags = 1
        XCTAssertEqual(0.95, basket.dollarValue)
    }
    
    func testDollarString() {
        basket.milkBottles = 2
        XCTAssertEqual("$ 2.60", basket.dollarString)
    }
}
