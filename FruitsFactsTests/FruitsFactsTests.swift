//
//  FruitsFactsTests.swift
//  FruitsFactsTests
//
//  Created by Kumar Sharma on 12/05/21.
//

import XCTest
@testable import FruitsFacts
//@testable import FactPresenter

let presenter = FactPresenter()

class FruitsFactsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNextQuote(){
        
        let result = presenter.nextQuoteText()
        XCTAssert(result.count>0, "Method did not return any quote!")
    }
    
    func testPreviousQuote(){
        
        let result = presenter.previousQuoteText()
        XCTAssert(result.count>0, "Method did not return any quote!")
    }

}
