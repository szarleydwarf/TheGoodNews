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
    
    func testFetchedFavouritsNotNil() {
        XCTAssertNotNil( favouritesUnderTest.fetchFavourites(view: UIView()))
        
    }

    func testSavetoFavouritesTrue() {
        XCTAssertTrue(favouritesUnderTest.saveFavourite(authorName: "AUTHOR", quote: "SOME QUOTE"))
    }

    func testDeleteFromFavouritesTrue () {
        XCTAssertTrue(favouritesUnderTest.deleteFavourite(author: "AUTHOR", quote: "SOME QOUTE"))
    }

    func testSavetoFavouritesFalse() {
        XCTAssertFalse(favouritesUnderTest.saveFavourite(authorName: "AUTHOR", quote: "SOME QUOTE"))
    }
    

    func testDeleteFromFavouritesFalse () {
        XCTAssertFalse(favouritesUnderTest.deleteFavourite(author: "AUTHOR", quote: "SOME QOUTE"))
    }
    
    func testIfFavouriteTrue(){
        XCTAssertTrue(favouritesUnderTest.checkIfFavourite(authorName: "AUTHOR", quote: "SOME QOUTE", favourites: favouritesUnderTest.fetchFavourites(view: UIView())))
    }
    
    func testIfFavouriteFalse(){
        XCTAssertFalse(favouritesUnderTest.checkIfFavourite(authorName: "Confucius", quote: "When we see men of worth, we should think of equaling them; when we see men of a contrary character, we should turn inwards and examin", favourites: favouritesUnderTest.fetchFavourites(view: UIView())))
    }
    
    
}
