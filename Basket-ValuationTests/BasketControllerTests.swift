//
//  BasketControllerTests.swift
//  Basket-Valuation
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import XCTest
@testable import Basket_Valuation

class BasketControllerTests: XCTestCase {
    var basketController: BasketController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let initialController = storyboard.instantiateInitialViewController() as? BasketController {
            basketController = initialController
            // The One Weird Trick! (which connects the outlets)
            // let _ = basketController.view
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyBasketGeneration() {
        XCTAssert(basketController.basket().empty)
    }
    
    func testPeaBasketGeneration() {
        basketController.peasField.text = "2"
        
        XCTAssert(!basketController.basket().empty)
        XCTAssertEqual(2, basketController.basket().peaBags)
    }
    
    func testEggBasketGeneration() {
        basketController.eggsField.text = "3"
        
        XCTAssert(!basketController.basket().empty)
        XCTAssertEqual(3, basketController.basket().eggDozens)
    }
    
    func testMilkBasketGeneration() {
        basketController.milkField.text = "4"
        
        XCTAssert(!basketController.basket().empty)
        XCTAssertEqual(4, basketController.basket().milkBottles)
    }
    
    func testBeansBasketGeneration() {
        basketController.beansField.text = "5"
        
        XCTAssert(!basketController.basket().empty)
        XCTAssertEqual(5, basketController.basket().beanCans)
        XCTAssertEqual(0, basketController.basket().milkBottles)
    }
}
