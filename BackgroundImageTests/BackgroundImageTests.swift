//
//  BackgroundImageTests.swift
//  BackgroundImageTests
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import XCTest
@testable import TheGoodNewsFinalProject

class BackgroundImageTests: XCTestCase {
    var backgroudImagesUnderTest:Backgrounds!
    
    override func setUp() {
        super.setUp()
        backgroudImagesUnderTest = Backgrounds()
    
    }

    override func tearDown() {
        backgroudImagesUnderTest = nil
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
