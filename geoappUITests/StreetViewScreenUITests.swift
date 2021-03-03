//
//  StreetViewScreenUITests.swift
//  geoappUITests
//
//  Created by Quan Dao on 3.5.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import XCTest

class StreetViewScreenUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        if (!app.buttons["Sign Out"].exists) {
            app/*@START_MENU_TOKEN@*/.buttons["Sign In"]/*[[".otherElements[\"loginView\"].buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            app/*@START_MENU_TOKEN@*/.textFields["username"]/*[[".textFields[\"USERNAME\"]",".textFields[\"username\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.keys["a"].tap()
            app.keys["b"].tap()
            app.keys["c"].tap()
            app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"Nhập\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            app/*@START_MENU_TOKEN@*/.secureTextFields["password"]/*[[".secureTextFields[\"PASSWORD\"]",".secureTextFields[\"password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"số\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["4"]/*[[".keyboards.keys[\"4\"]",".keys[\"4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"Nhập\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            app.buttons["loginSignIn"].tap()
        }
        app/*@START_MENU_TOKEN@*/.buttons["Normal"]/*[[".otherElements[\"homeView\"].buttons[\"Normal\"]",".buttons[\"Normal\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        while app.activityIndicators["In progress"].exists {
        }
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testGuessShowGuessScreen() {
        app.buttons["GUESS"].tap()
        
        XCTAssertTrue(app.otherElements["guessMapView"].exists)
        XCTAssertFalse(app.otherElements["streetView"].exists)
    }
    
    func testBackShowConfirmAlerts() {
        app.buttons["backButton"].tap()
        
        XCTAssertTrue(app.alerts["Do you want to quit?"].exists)
    }
    
    func testConfirmBackShowHomeScreen() {
        app.buttons["backButton"].tap()
        
        app.alerts["Do you want to quit?"].scrollViews.otherElements.buttons["Confirm"].tap()
        
        XCTAssertTrue(app.otherElements["homeView"].waitForExistence(timeout: 1))
        XCTAssertFalse(app.otherElements["streetView"].exists)
    }
    
    func testCancelBackContinuesStreetView() {
        app.buttons["backButton"].tap()
        
        app.alerts["Do you want to quit?"].scrollViews.otherElements.buttons["Cancel"].tap()
        
        XCTAssertFalse(app.otherElements["homeView"].exists)
    }
}
