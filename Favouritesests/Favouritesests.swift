//
//  FavouritesTests.swift
//  FavouritesTests
//
//  Created by The App Experts on 15/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import XCTest
@testable import TheGoodNewsFinalProject

class FavouritesTests: XCTestCase {
    var favouritesUnderTest: Favourites!

    override func setUp() {
        super.setUp()
        favouritesUnderTest = Favourites()
    }

    override func tearDown() {
        favouritesUnderTest = nil
        super.tearDown()
    }

    func testFetchedFavouritsNil() {
        XCTAssertNil( favouritesUnderTest.fetchFavourites(view: UIView()))
        
    }


}
