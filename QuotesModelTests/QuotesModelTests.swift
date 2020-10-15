//
//  QuotesModelTests.swift
//  QuotesModelTests
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import XCTest
@testable import TheGoodNewsFinalProject

class QuotesModelTests: XCTestCase {
    var qutesModelUnderTest:Quotes!
    
    override func setUp() {
        super.setUp()
        qutesModelUnderTest = Quotes()
    }
    
    override func tearDown() {
        qutesModelUnderTest = nil
        super.tearDown()
    }
    
    func testQuoteNil() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssertNil(quote)
        }
    }
    
    func testAuthorNil() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssertNil(author)
        }
    }
    
    func testQuoteNotNil() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssertNotNil(quote)
        }
    }
    
    func testAuthorNotNil() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssertNotNil(author)
        }
    }
    
    func testAuthorEmpty() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssert(author == "")
        }
    }
    
    func testQuoteEmpty() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssert(quote == "")
        }
    }
    
    func testAuthorNotEmpty() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssert(author != "")
        }
    }
    
    func testQuoteNotEmpty() {
        qutesModelUnderTest.getQuote{author, quote in
            XCTAssert(quote != "")
        }
    }
    

}
