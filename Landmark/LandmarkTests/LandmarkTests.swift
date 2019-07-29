//
//  LandmarkTests.swift
//  LandmarkTests
//
//  Created by Harish V V on 27/07/19.
//  Copyright © 2019 Company. All rights reserved.
//

import XCTest
@testable import Landmark

class LandmarkTests: XCTestCase {
    
    var serviceLayer: ServiceLayer!
    var productManager: ProductManager!
    var viewController: ContainerViewController!
    var window: UIWindow!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        serviceLayer = ServiceLayer()
        productManager = ProductManager()
        viewController = ContainerViewController()
        window = UIWindow()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        serviceLayer = nil
        productManager = nil
        viewController = nil
    }
    
    func loadView() {
        window.addSubview(viewController.view)
        RunLoop.current.run(until: Date())
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    /////
    ////Service Layer test cases
    func testServiceRequest() {
        let expectation = self.expectation(description: "ProductList")
        var value: [String: Any]?
        
        serviceLayer.serviceRequestWithURL(url: URL_STRINGS.PRODUCT_LIST) { (result) in
            if result.hasResult {
                value = result.value as? [String: Any]
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(((value?.count) != nil))
    }
    
    
    func testMockRequest() {
        let expectation = self.expectation(description: "ProductList")
        var value: [String: Any]?
        
        serviceLayer.mockRequestWithURL(url: URL_STRINGS.PRODUCT_LIST) { (result) in
            if result.hasResult {
                value = result.value as? [String: Any]
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(((value?.count) != nil))
    }
    
    
    func testDataRequest() {
        serviceLayer.dataRequestWith(url: URL_STRINGS.PRODUCT_LIST) { (result) in
            XCTAssert(self.serviceLayer.isMock)
        }
    }
    
    
    ////
    ////CurrencyHandler test cases
    func testUpdateSelectedCurrency() {
        let mockCurrecy = "INR"
        CurrencyHandler.sharedInstance.updateCurrency(currency: mockCurrecy)
        
        XCTAssertEqual(CurrencyHandler.sharedInstance.currentCurrency, mockCurrecy)
    }
    
    
    ////
    ////ContainerVC test cases
    func testUpdateTimer() {   
        let timerValue = self.viewController.updateTimer()
        XCTAssert(timerValue.count != 0)
    }

}
