//
//  HomeScreenUITest.swift
//  geoappUITests
//
//  Created by Nhan Nguyen on 4.5.2020.
//  Copyright © 2020 team geo app. All rights reserved.
//

import XCTest

class HomeScreenUITest: XCTestCase {

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
            app.buttons["Return"].tap()
            
            app.buttons["loginSignIn"].tap()
        }
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testMainViewExistWhenPressSignOut() {
        app.buttons["Sign Out"].tap()

        XCTAssertTrue(app.otherElements["mainView"].exists)
    }
    
    // MARK: - LeaderBoard

    func testNormalTableExistWhenPressScoreBoard() {
        app.buttons["Score Board"].tap()
        
        let normalTable = app.tables["normalTable"]
        XCTAssertTrue(normalTable.exists)
    }
    
    func testChallengeTableExistWhenPressScoreBoard() {
        app.buttons["Score Board"].tap()
        app.tabBars.buttons["Challenge"].tap()
        
        let challengeTable = app.tables["challengeTable"]
        XCTAssertTrue(challengeTable.exists)
    }

    func testStreetViewExistWhenPressNormalBtn() {
            app.buttons["Normal"].tap()

            XCTAssertTrue(app.otherElements["streetView"].exists)
    }
    
    func testStreetViewExistWhenPressChallengeBtn() {
            app.buttons["Challenge"].tap()

            XCTAssertTrue(app.otherElements["challengeView"].exists)
    }

}
