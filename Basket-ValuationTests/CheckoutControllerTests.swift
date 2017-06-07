//
//  CheckoutControllerTests.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import XCTest
@testable import Basket_Valuation

class CheckoutControllerTests: XCTestCase {
    var checkoutController : CheckoutController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let controller = storyboard.instantiateViewController(withIdentifier: "CheckoutController") as? CheckoutController {
            checkoutController = controller
            // The One Weird Trick! (which connects the outlets)
            let _ = checkoutController.view
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyBasket() {
        XCTAssert(checkoutController.basket.empty)
        XCTAssertEqual("Your basket is empty", checkoutController.summaryField.text!)
        XCTAssertEqual("$ 0.00", checkoutController.dollarLabel.text)
    }
    
    func testSimpleBasket() {
        checkoutController.basket = Basket(milkBottles: 3)
        XCTAssert(checkoutController.summaryField.text!.contains("3 bottles of milk"))
        XCTAssertEqual("$ 3.90", checkoutController.dollarLabel.text)
    }
    
    func testFullBasket() {
        checkoutController.basket = Basket(peaBags: 2, eggDozens: 3, milkBottles: 5, beanCans: 7)
        XCTAssert(checkoutController.summaryField.text!.contains("7 cans of beans"))
        XCTAssert(checkoutController.summaryField.text!.contains("3 dozen eggs"))
        XCTAssertEqual("$ 19.81", checkoutController.dollarLabel.text)
    }
    
    func testConvertedBasket() {
        checkoutController.converter = MockConverter()
        checkoutController.basket = Basket(beanCans: 4)
        XCTAssertEqual("$ 2.92", checkoutController.dollarLabel.text)
        XCTAssertEqual("2.89 CHF", checkoutController.convertedLabel.text)
    }
    
    func testInitializingRates() {
        checkoutController.basket = Basket(eggDozens: 2)
        XCTAssertEqual("$ 4.20", checkoutController.dollarLabel.text)
        XCTAssertEqual("initializing rates", checkoutController.convertedLabel.text)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
