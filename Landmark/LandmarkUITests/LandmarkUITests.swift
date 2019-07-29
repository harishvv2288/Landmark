//
//  LandmarkUITests.swift
//  LandmarkUITests
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import XCTest

class LandmarkUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let collectionViewExists = app.collectionViews.cells.element.exists
        let segmentViewwithINRExists = app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["INR"]/*[[".segmentedControls.buttons[\"INR\"]",".buttons[\"INR\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists
        let segmentViewwithAEDExists = app.segmentedControls.buttons["AED"].exists
        let segmentViewwithSARExists = app.segmentedControls.buttons["SAR"].exists
//        let timerExists = app.staticTexts["443131:52:29 Left"].exists
        XCTAssert(collectionViewExists == true)
        XCTAssert(segmentViewwithINRExists == true)
        XCTAssert(segmentViewwithAEDExists == true)
        XCTAssert(segmentViewwithSARExists == true)
    }

}
