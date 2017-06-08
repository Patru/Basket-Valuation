//
//  Basket_ValuationUITests.swift
//  Basket-ValuationUITests
//
//  Created by Paul Trunz on 02.06.17.
//  Copyright © 2017 Soft-Werker GmbH. All rights reserved.
//

import XCTest

class Basket_ValuationUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        XCUIDevice.shared().orientation = .portrait
        continueAfterFailure = false
        XCUIApplication().launch()

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHappyPath() {
        let app = XCUIApplication()
        let eggdozensfieldTextField = app.textFields["EggDozensField"]
        eggdozensfieldTextField.tap()
        eggdozensfieldTextField.typeText("2")
        
        let milkbottlesfieldTextField = app.textFields["MilkBottlesField"]
        milkbottlesfieldTextField.tap()
        milkbottlesfieldTextField.typeText("1")
        
        let beancansfieldTextField = app.textFields["BeanCansField"]
        beancansfieldTextField.tap()
        beancansfieldTextField.typeText("4")
        app.buttons["endEditingButton"].tap()
        app.buttons["CheckoutButton"].tap()
        let dollarAmount = app.staticTexts["dollarAmount"]
        XCTAssertEqual("$ 8.42", dollarAmount.label)
        let rate = app.staticTexts["RateLabel"]
        let ratesInitialized = NSPredicate(format: "label BEGINSWITH 'Rate:'")
        let hasRate = expectation(for: ratesInitialized, evaluatedWith: rate, handler: nil)
        wait(for: [hasRate], timeout: 5)
        
        app.pickerWheels.element.adjust(toPickerWheelValue: "USD")
        let convertedAmount = app.staticTexts["convertedAmount"]
        XCTAssertEqual("8.42 USD", convertedAmount.label)
        
        app.pickerWheels.element.adjust(toPickerWheelValue: "CHF")
        XCTAssert(convertedAmount.label.contains("CHF"))
    }
    
    func testReturnToBasket() {
        let app = XCUIApplication()
        let eggdozensfieldTextField = app.textFields["EggDozensField"]
        eggdozensfieldTextField.tap()
        eggdozensfieldTextField.typeText("2")
        
        app.buttons["endEditingButton"].tap()
        
        app.buttons["CheckoutButton"].tap()
        let dollarAmount = app.staticTexts["dollarAmount"]
        XCTAssertEqual("$ 4.20", dollarAmount.label)
        let rate = app.staticTexts["RateLabel"]
        let rateInitialized = NSPredicate(format: "label BEGINSWITH 'Rate:'")
        let hasRate = expectation(for: rateInitialized, evaluatedWith: rate, handler: nil)
        wait(for: [hasRate], timeout: 5)
        
        app.buttons["BackToBasketButton"].tap()
        
        let beancansfieldTextField = app.textFields["BeanCansField"]
        beancansfieldTextField.tap()
        beancansfieldTextField.typeText("5")
        
        app.buttons["endEditingButton"].tap()
        app.buttons["CheckoutButton"].tap()
        XCTAssertEqual("$ 7.85", dollarAmount.label)
        wait(for: [hasRate], timeout: 5)
        app.pickerWheels.element.adjust(toPickerWheelValue: "EUR")
        XCTAssert(app.staticTexts["convertedAmount"].label.contains("EUR"))
    }
    
    func testNonDigits() {
        // should not happen on device because of the selected keyboard, but the simulator only rarely reflects this
        let app = XCUIApplication()
        let eggdozensfieldTextField = app.textFields["EggDozensField"]
        eggdozensfieldTextField.tap()
        eggdozensfieldTextField.typeText("dkk")
        
        let beancansfieldTextField = app.textFields["BeanCansField"]
        beancansfieldTextField.tap()
        beancansfieldTextField.typeText("x")

        app.buttons["endEditingButton"].tap()
        
        app.buttons["CheckoutButton"].tap()
        let dollarAmount = app.staticTexts["dollarAmount"]
        XCTAssertEqual("$ 0.00", dollarAmount.label)
    }
    
    func testFractionalNumbers() {
        let app = XCUIApplication()
        let eggdozensfieldTextField = app.textFields["EggDozensField"]
        eggdozensfieldTextField.tap()
        eggdozensfieldTextField.typeText("2.5")
        
        let beancansfieldTextField = app.textFields["BeanCansField"]
        beancansfieldTextField.tap()
        beancansfieldTextField.typeText(".9")
        
        app.buttons["endEditingButton"].tap()
        
        app.buttons["CheckoutButton"].tap()
        let dollarAmount = app.staticTexts["dollarAmount"]
        XCTAssertEqual("$ 0.00", dollarAmount.label)
        // not parseable as ints, good enough for now as "." is not on the number pad
    }
    
    func testNegativeNumbers() {
        let app = XCUIApplication()
        let peabagsTextField = app.textFields["PeaBagsField"]
        peabagsTextField.tap()
        peabagsTextField.typeText("-2")
        
        let milkBottlesTextField = app.textFields["MilkBottlesField"]
        milkBottlesTextField.tap()
        milkBottlesTextField.typeText("-3")
        
        app.buttons["endEditingButton"].tap()
        
        app.buttons["CheckoutButton"].tap()
        let dollarAmount = app.staticTexts["dollarAmount"]
        XCTAssertEqual("$ -5.80", dollarAmount.label, "unusual but acceptable since '-' is not on the number pad")
        // unusual but acceptable since "-" is not on the number pad
    }
}
