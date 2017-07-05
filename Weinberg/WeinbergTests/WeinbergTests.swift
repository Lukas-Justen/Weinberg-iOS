//
//  WeinbergTests.swift
//  WeinbergTests
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import XCTest
@testable import Weinberg

class WeinbergTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRadians() {
        let result:Double = MapDrawer.radians(degrees: 180)
        XCTAssertEqual(Double.pi,result)
    }
    
    func testCreateNewField() {
        //let mapDrawer:MapDrawer = MapDrawer(mapView:,fabCreate:nil,labelMarkPoints:nil)
        //let field:Field = mapDrawer.createNewField()
        //XCTAssertNotNil(field)
    }
    
 
}
