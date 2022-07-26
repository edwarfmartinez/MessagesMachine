//
//  MessageMachineUITests.swift
//  MessageMachineUITests
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//

import XCTest


class MessageMachineUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
    func testMessageConfig(){
        
        login()
        
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        let tabConfig = tabBar.buttons["advanced"] // config tab
        let tabConfigExists = tabConfig.waitForExistence(timeout: 10)
        print("testLogin: Tab config Exists?: \(tabConfigExists)")
        tabConfig.tap()
        tabConfig.tap()
        XCUIApplication().staticTexts["New message"].tap()
        
        XCUIApplication().textFields["messageTextField"].tap()
        XCUIApplication().textFields["messageTextField"].typeText("UITest message")
        XCUIApplication().toolbars["Toolbar"].buttons["Done"].tap()
        
        XCUIApplication().textFields["emailTextField"].tap()
        XCUIApplication().textFields["emailTextField"].typeText("one@test.com")
        XCUIApplication().toolbars["Toolbar"].buttons["Done"].tap()
        
        XCUIApplication().buttons["btnAddReceiver"].tap()
        XCUIApplication().staticTexts["Save message"].tap()
        
        print("testLogin: Table rows: \(XCUIApplication().tables.cells.count)")
        
        XCTAssertGreaterThan(XCUIApplication().tables.cells.count, 1, "There should be 1 row at least")
        
    }
    
    func testMessagesView(){
        
        login()
        
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        tabBar.buttons["chart pie"].tap()
        tabBar.buttons["advanced"].tap()
        tabBar.buttons["conversation"].tap()
        
        let tabMessages = tabBar.buttons["conversation"] // config tab
        let tabMessagesExists = tabMessages.waitForExistence(timeout: 10)
        print("testLogin: tabMessagesExists?: \(tabMessages)")
        tabMessages.tap()
        tabMessages.tap()
        
        
        let table = XCUIApplication().tables["MessagesTableView"]
        //let tabConfig = tabBar.buttons["advanced"]
        let tableExists = table.waitForExistence(timeout: 2)
        print("testLogin: tableExists?: \(tableExists)")
        
        
    }
    
    func login(){
        
        let app = XCUIApplication()
        app.launch()
        let logInStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Log In"]/*[[".buttons[\"Log In\"].staticTexts[\"Log In\"]",".staticTexts[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        logInStaticText.tap()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("")
        emailTextField.typeText("one@test.com")
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).tap()
        
        UIPasteboard.general.string = "123456"
        app.secureTextFields["Password"].doubleTap()
        app.menuItems["Paste"].tap()
        logInStaticText.tap()
        
        
    }
}
