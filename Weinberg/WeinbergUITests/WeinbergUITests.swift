//
//  WeinbergUITests.swift
//  WeinbergUITests
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import XCTest
import RealmSwift
import DatePickerDialog



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The UITests test all common features of our app.
 */
class WeinbergUITests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    
    func testAddSortSearchSelectDeleteOperation() {
        let app = XCUIApplication()
        app.navigationBars["Weingut"].buttons["add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Ausbessern")
        app.buttons["Return"].tap()
        app.staticTexts["z.B. 15.03.2017"].tap()
        let fertigButton = app.buttons["Fertig"]
        fertigButton.tap()
        app.staticTexts["z.B. 25.04.2017"].tap()
        fertigButton.tap()
        app.staticTexts["z.B. 2:30"].tap()
        fertigButton.tap()
        app.buttons["Clear text"].tap()
        nameTextField.typeText("Umwälzen")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        
        let statusHaButton = app.buttons["Status (ha)"]
        statusHaButton.tap()
        let nameButton = app.buttons["Name"]
        nameButton.tap()
        nameButton.tap()
        nameButton.tap()
        statusHaButton.tap()
        statusHaButton.tap()
        statusHaButton.tap()
        nameButton.tap()
        statusHaButton.tap()
        nameButton.tap()
        
        let arbeitSuchenSearchField = XCUIApplication().searchFields["Arbeit suchen"]
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.typeText("Spritzen 7")
        arbeitSuchenSearchField.buttons["Clear text"].tap()
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.typeText("Umwälzen")
        app.buttons["Search"].tap()
        
        app.tables.cells["OperationCell"].tap()
        app.tabBars.buttons["Arbeiten"].tap()
        
        app.tables.cells["OperationCell"].swipeLeft()
        XCUIApplication().tables.buttons["Löschen"].tap()
    }
    
    func testAddEditCheckResetDeleteOperation() {
        let app = XCUIApplication()
        app.navigationBars["Weingut"].buttons["add"].tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Ausbessern")
        app.buttons["Return"].tap()
        app.staticTexts["z.B. 15.03.2017"].tap()
        let fertigButton = app.buttons["Fertig"]
        fertigButton.tap()
        app.staticTexts["z.B. 25.04.2017"].tap()
        fertigButton.tap()
        app.staticTexts["z.B. 2:30"].tap()
        fertigButton.tap()
        app.buttons["Clear text"].tap()
        nameTextField.typeText("Umwälzen")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        
        let arbeitSuchenSearchField = XCUIApplication().searchFields["Arbeit suchen"]
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.typeText("Umwälzen")
        app.buttons["Search"].tap()
        app.tables.cells["OperationCell"].swipeLeft()
        XCUIApplication().tables.buttons["Editieren"].tap()
        app.buttons["Clear text"].tap()
        app.textFields["Name"].typeText("Umgraben")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        
        app.tabBars.buttons["Felder"].tap()
        app.navigationBars["FieldNavigationItemID"].buttons["add"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let map = element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        map.tap()
        map.tap()
        map.tap()
        element.children(matching: .other).element(boundBy: 1).tap()
        let nameFieldTextField = app.textFields["Name"]
        nameFieldTextField.tap()
        nameFieldTextField.typeText("Mörderhölle")
        app.buttons["Return"].tap()
        let normalerziehungTextField = app.textFields["Normalerziehung"]
        normalerziehungTextField.tap()
        normalerziehungTextField.typeText("Normalerziehung")
        app.buttons["Return"].tap()
        let rieslingTextField = app.textFields["Riesling"]
        rieslingTextField.tap()
        rieslingTextField.typeText("Riesling")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        app.tabBars.buttons["Arbeiten"].tap()
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.buttons["Clear text"].tap()
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.typeText("Umgraben")
        app.buttons["Search"].tap()
        app.tables.cells["OperationCell"].tap()
        app.tabBars.buttons["Felder"].tap()
        app.tables.cells["FieldCell"].buttons["checkFieldStatus"].tap()
        app.tabBars.buttons["Arbeiten"].tap()
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.buttons["Clear text"].tap()
        let statusHaButton = app.buttons["Status (ha)"]
        statusHaButton.tap()
        statusHaButton.tap()
        statusHaButton.tap()
        app.tabBars.buttons["Karte"].tap()
        let renewButton = app.navigationBars["MapNavigationItemID"].buttons["renew"]
        renewButton.tap()
        app.alerts["Zurücksetzen"].buttons["Zurücksetzen"].tap()
        renewButton.tap()
        
        app.tabBars.buttons["Arbeiten"].tap()
        arbeitSuchenSearchField.tap()
        arbeitSuchenSearchField.typeText("Umgraben")
        app.buttons["Search"].tap()
        app.tables.cells["OperationCell"].swipeLeft()
        XCUIApplication().tables.buttons["Löschen"].tap()
        
        app.tabBars.buttons["Felder"].tap()
        app.tables.cells["FieldCell"].swipeLeft()
        XCUIApplication().tables.buttons["Löschen"].tap()
    }
    
    func testAddSelectSortSearchDeleteFieldFromMap() {
        let app = XCUIApplication()
        app.tabBars.buttons["Karte"].tap()
        app.navigationBars["MapNavigationItemID"].buttons["add"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let map = element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        map.tap()
        map.tap()
        map.tap()
        element.children(matching: .other).element(boundBy: 1).tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Höllenberg")
        app.buttons["Return"].tap()
        let normalerziehungTextField = app.textFields["Normalerziehung"]
        normalerziehungTextField.tap()
        normalerziehungTextField.typeText("Umkehranlage")
        app.buttons["Return"].tap()
        let rieslingTextField = app.textFields["Riesling"]
        rieslingTextField.tap()
        rieslingTextField.typeText("Kanzler")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        
        let felderButton = app.tabBars.buttons["Felder"]
        felderButton.tap()
        app.tables.cells["FieldCell"].tap()
        felderButton.tap()
        app.tables.cells["FieldCell"].tap()
        felderButton.tap()
        
        let flCheMButton = app.buttons["Fläche (m²)"]
        flCheMButton.tap()
        let nameButton = app.buttons["Name"]
        nameButton.tap()
        nameButton.tap()
        flCheMButton.tap()
        flCheMButton.tap()
        flCheMButton.tap()
        
        let feldSuchenSearchField = XCUIApplication().searchFields["Feld suchen"]
        feldSuchenSearchField.tap()
        feldSuchenSearchField.typeText("Himmelsau")
        feldSuchenSearchField.buttons["Clear text"].tap()
        feldSuchenSearchField.tap()
        feldSuchenSearchField.typeText("Höllenberg")
        app.buttons["Search"].tap()
        app.tables.cells["FieldCell"].tap()
        app.tabBars.buttons["Felder"].tap()
        
        app.tabBars.buttons["Felder"].tap()
        app.tables.cells["FieldCell"].swipeLeft()
        XCUIApplication().tables.buttons["Löschen"].tap()
    }
    
    func testAddEditCheckDeleteFieldFromFields() {
        let app = XCUIApplication()
        app.tabBars.buttons["Felder"].tap()
        app.navigationBars["FieldNavigationItemID"].buttons["add"].tap()
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let map = element.children(matching: .other).element.children(matching: .other).element.children(matching: .map).element
        map.tap()
        map.tap()
        map.tap()
        element.children(matching: .other).element(boundBy: 1).tap()
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("Mörderhölle")
        app.buttons["Return"].tap()
        let normalerziehungTextField = app.textFields["Normalerziehung"]
        normalerziehungTextField.tap()
        normalerziehungTextField.typeText("Normalerziehung")
        app.buttons["Return"].tap()
        let rieslingTextField = app.textFields["Riesling"]
        rieslingTextField.tap()
        rieslingTextField.typeText("Riesling")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
 
        XCUIApplication().tabBars.buttons["Felder"].tap()
        XCUIApplication().tables.cells["FieldCell"].swipeLeft()
        XCUIApplication().tables.buttons["Editieren"].tap()
        let nameTextFieldEdit = app.textFields["Name"]
        nameTextFieldEdit.tap()
        nameTextFieldEdit.typeText(" 1")
        app.buttons["Return"].tap()
        let normalErziehung = app.textFields["Normalerziehung"]
        normalErziehung.tap()
        normalErziehung.typeText(" Spezial")
        app.buttons["Return"].tap()
        let rieslingTextField2 = app.textFields["Riesling"]
        rieslingTextField2.buttons["Clear text"].tap()
        rieslingTextField2.typeText("Kanzler")
        app.buttons["Return"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).tap()
        
        let tabBarsQuery = XCUIApplication().tabBars
        let karteButton = tabBarsQuery.buttons["Karte"]
        let felderButton = tabBarsQuery.buttons["Felder"]
        app.tables.cells["FieldCell"].buttons["checkFieldStatus"].tap()
        karteButton.tap()
        felderButton.tap()
        app.tables.cells["FieldCell"].buttons["checkFieldStatus"].tap()
        karteButton.tap()
        felderButton.tap()
        app.tables.cells["FieldCell"].buttons["checkFieldStatus"].tap()
        
        app.tables.cells["FieldCell"].swipeLeft()
        XCUIApplication().tables.buttons["Löschen"].tap()
    }
    
}
