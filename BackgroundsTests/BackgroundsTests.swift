//
//  BackgroundsTests.swift
//  BackgroundsTests
//
//  Created by The App Experts on 06/11/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import XCTest
@testable import TheGoodNewsFinalProject

class BackgroundsTests: XCTestCase {
    var backgroudImagesUnderTest:Backgrounds!
    
    override func setUp() {
        super.setUp()
        backgroudImagesUnderTest = Backgrounds()
    
    }

    override func tearDown() {
        backgroudImagesUnderTest = nil
        super.tearDown()
    }

    func testURLnil() {
        backgroudImagesUnderTest.getBackgroundImage{url in
            XCTAssertNil(url)
        }
    }
    
    func testURLNotNil() {
        backgroudImagesUnderTest.getBackgroundImage{ url in
            XCTAssertNotNil(url)
        }
    }

    func testURLEmpty() {
        backgroudImagesUnderTest.getBackgroundImage {url in
            XCTAssert(url.absoluteString == "")
        }
    }

    
    func testURLNotEmpty() {
        backgroudImagesUnderTest.getBackgroundImage {url in
            XCTAssert(url.absoluteString != "")
        }
    }
}
