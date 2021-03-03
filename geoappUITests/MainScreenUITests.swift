//
//  MainScreenUITests.swift
//  geoappUITests
//
//  Created by Quan Dao on 30.4.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import XCTest

class MainScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        app = XCUIApplication()
//        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func checkSignOut() {
        if (app.buttons["Sign Out"].exists) {
            app.buttons["Sign Out"].tap()
        }
    }
    
    func testSignInAndRegsiterViewNotShownOnStart() {
        app = XCUIApplication()
        app.launch()
        
        checkSignOut()
        
        XCTAssertFalse(app.otherElements["loginView"].exists)
        XCTAssertFalse(app.otherElements["registerView"].exists)
    }

    func testSignInButtonShowsSignInScreen() {
        app = XCUIApplication()
        app.launch()
        
        checkSignOut()
        
        app.buttons["Sign In"].tap()
        
        XCTAssertTrue(app.otherElements["loginView"].exists)
    }
    
    func testSignUpButtonShowsSignUpScreen() {
        app = XCUIApplication()
        app.launch()
        
        checkSignOut()
        
        app.buttons["Sign Up"].tap()
    
        XCTAssertTrue(app.otherElements["registerView"].exists)
    }
    
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
