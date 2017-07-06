//
//  WeinbergUITests.swift
//  WeinbergUITests
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import XCTest

class WeinbergUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    func testSearchOperation() {
        let arbeitSuchenSearchField = XCUIApplication().searchFields["Arbeit suchen"]
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.typeText("Spritzen 7")
        arbeitSuchenSearchField.buttons["Clear text"].tap()
    }
    
    func testSortOperation() {
        let app = XCUIApplication()
        let statusHaButton = app.buttons["Status (ha)"]
        statusHaButton.tap()
        let nameButton = app.buttons["Name"]
        nameButton.tap()
        nameButton.tap()
        nameButton.tap()
        statusHaButton.tap()
        statusHaButton.tap()
        statusHaButton.tap()
    }
    
    func testSelectOperation() {
        let app = XCUIApplication()
        app.tabBars.buttons["Arbeiten"].tap()
        app.tables.staticTexts["Biegen"].tap()
    }
    
    func testAddOperation() {
        XCUIApplication().navigationBars["Weingut"].children(matching: .button).element.tap()
        
        let app = XCUIApplication()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText(helperRandomString())
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        
    }
    
    func testSearchField() {
        XCUIApplication().tabBars.buttons["Felder"].tap()
        let feldSuchenSearchField = XCUIApplication().searchFields["Feld suchen"]
        feldSuchenSearchField.tap()
        feldSuchenSearchField.typeText("Himmelsau")
        feldSuchenSearchField.buttons["Clear text"].tap()
        
    }
    
    func testSortField() {
        let app = XCUIApplication()
        app.tabBars.buttons["Felder"].tap()
        let flCheMButton = app.buttons["Fläche (m²)"]
        flCheMButton.tap()
        let nameButton = app.buttons["Name"]
        nameButton.tap()
        nameButton.tap()
        flCheMButton.tap()
        flCheMButton.tap()
        flCheMButton.tap()
        
    }
    
    func testSelectField() {
        let app = XCUIApplication()
        let felderButton = app.tabBars.buttons["Felder"]
        felderButton.tap()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Höllenberg"].tap()
        felderButton.tap()
        tablesQuery.staticTexts["Kirchberg"].tap()
    }
    
    func testAddFieldFromMap() {
        let app = XCUIApplication()
        app.tabBars.buttons["Karte"].tap()
        app.navigationBars["Spritzen 6"].buttons["add"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        let map = element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        map.tap()
        map.tap()
        map.tap()
        element.children(matching: .other).element(boundBy: 1).tap()
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText(helperRandomString())
        app.buttons["Return"].tap()
        
        let normalerziehungTextField = app.textFields["Normalerziehung"]
        normalerziehungTextField.tap()
        normalerziehungTextField.typeText(helperRandomString())
        app.buttons["Return"].tap()
        
        let rieslingTextField = app.textFields["Riesling"]
        rieslingTextField.tap()
        rieslingTextField.typeText("ghj")
        app.buttons["Return"].tap()
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
    }
    
    
    func testAddFieldFromFields() {
        let app = XCUIApplication()
        app.tabBars.buttons["Felder"].tap()
        app.navigationBars["Spritzen 6"].buttons["add"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        let map = element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        map.tap()
        map.tap()
        map.tap()
        element.children(matching: .other).element(boundBy: 1).tap()
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText(helperRandomString())
        app.buttons["Return"].tap()
        
        let normalerziehungTextField = app.textFields["Normalerziehung"]
        normalerziehungTextField.tap()
        normalerziehungTextField.typeText(helperRandomString())
        app.buttons["Return"].tap()
        
        let rieslingTextField = app.textFields["Riesling"]
        rieslingTextField.tap()
        rieslingTextField.typeText("ghj")
        app.buttons["Return"].tap()
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
    }
    
    
    
    func helperRandomString() -> String {
        var c:[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
        var s:String = ""
        for _ in (1...20) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    
}
