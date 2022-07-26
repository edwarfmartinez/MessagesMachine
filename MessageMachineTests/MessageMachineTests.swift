//
//  MessageMachineTests.swift
//  MessageMachineTests
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 3/06/22.
//

import XCTest


@testable import MessageMachine
import Firebase


class MessageMachineTests: XCTestCase {
    
    let messagesMachineManager = MessagesMachineManager()
    var messages : [Message] = []
    //var messageConfiguration = MessageConfiguration()

    var numDocsBefore = 0
    var numDocsAfter = 0

    
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: Messages tests

    func test1_MessageRead() {
        messagesMachineManager.messagesRead(fromInbox: true, fromCharts: false)
        let exp = XCTestExpectation(description: "test1_MessageRead expectation")

        _ = XCTWaiter.wait(for: [exp], timeout: 10.0)
        XCTAssertGreaterThan(messagesMachineManager.messages.count, 0, "All messages read")
    }

    func test2_MessageCreate() {
        
        test1_MessageRead()
        numDocsBefore = messagesMachineManager.messages.count
        let exp = XCTestExpectation(description: "test2_MessageCreate expectation")

        var testMessage = MessageConfiguration()
        testMessage.body = "XCTest message"
        testMessage.category = 3
        testMessage.date = Date().timeIntervalSince1970
        testMessage.docId = messagesMachineManager.generateMessageConfigurationId
        testMessage.sendTo = ["one@test.com"]
        messagesMachineManager.messageCreate(message: testMessage)
        
        _ = XCTWaiter.wait(for: [exp], timeout: 2)
        
        numDocsAfter = messagesMachineManager.messages.count
        print("testLogin: num messages after and before: \(numDocsAfter) - \(numDocsBefore)")
        
        XCTAssertTrue(numDocsAfter == numDocsBefore+1)
    }


    func test3_MessageReadQuickly() {
        measure {
            messagesMachineManager.messagesRead(fromInbox: true, fromCharts: false)
        }
    }
    
    //MARK: Message configuration tests

    func test4_MessageConfigurationRead(){
        let exp = XCTestExpectation(description: "test4_MessageConfigurationRead expectation")
        messagesMachineManager.messageConfigurationRead()
        _ = XCTWaiter.wait(for: [exp], timeout: 5.0)
        XCTAssertGreaterThan(messagesMachineManager.messagesConfiguration.count, 0, "All messages read")

    }

    func test5_MessageConfigurationCreate(){
        let exp = XCTestExpectation(description: "testMessageConfigurationCreate expectation")

        test4_MessageConfigurationRead()
        numDocsBefore = messagesMachineManager.messagesConfiguration.count
        var messageConfiguration = MessageConfiguration()
        
        messageConfiguration.body = "XCTest message config"
        messageConfiguration.category = 3
        messageConfiguration.date = Date().timeIntervalSince1970
        messageConfiguration.docId = messagesMachineManager.generateMessageConfigurationId
        messageConfiguration.frequency = 5
        messageConfiguration.sendTo = ["one@test.com"]
        messagesMachineManager.messageConfigurationCreateUpdate(message: messageConfiguration)

        _ = XCTWaiter.wait(for: [exp], timeout: 2)

        numDocsAfter = messagesMachineManager.messagesConfiguration.count
        
        print("testLogin: num docs messagesConfiguration after and before: \(numDocsAfter) - \(numDocsBefore)")

        XCTAssertTrue(numDocsAfter == numDocsBefore+1)

    }

    
    func test6_MessageConfigurationUpdate(){
        
        test4_MessageConfigurationRead()

        var documentForUpdate = messagesMachineManager.messagesConfiguration[0]
        
        print("testLogin: documentForUpdate: \(documentForUpdate.docId), \(documentForUpdate.body)")
        
        //Change de content of the document but no the Id
        documentForUpdate.body = "XCTest message config Update1"
        documentForUpdate.category = 4
        documentForUpdate.date = Date().timeIntervalSince1970
        //documentForUpdate.docId = messagesMachineManager.generateMessageConfigId
        documentForUpdate.frequency = 6
        documentForUpdate.sendTo = ["two@test.com"]
        messagesMachineManager.messageConfigurationCreateUpdate(message: documentForUpdate)

        let exp = XCTestExpectation(description: "testMessageConfigurationUpdate expectation")
        _ = XCTWaiter.wait(for: [exp], timeout: 2)
        
        // Read updated message
        test4_MessageConfigurationRead()

        let updatedDocument = messagesMachineManager.messagesConfiguration.filter({return $0.docId == documentForUpdate.docId}).first
        
        print("testLogin: updatedDocument: \(String(describing: updatedDocument?.docId)),  \(String(describing: updatedDocument?.body))")

        XCTAssertTrue(documentForUpdate.body != (String(describing: updatedDocument?.body)))
    
    }

    func test7_MessageConfigurationDelete(){
        test4_MessageConfigurationRead()
        numDocsBefore = messagesMachineManager.messagesConfiguration.count

        print("testLogin: DeleteDocument: \(messagesMachineManager.messagesConfiguration.first!.docId)")

        messagesMachineManager.messageConfigurationDelete(docId: messagesMachineManager.messagesConfiguration.first!.docId)

        let exp = XCTestExpectation(description: "testMessageConfigurationUpdate expectation")
        _ = XCTWaiter.wait(for: [exp], timeout: 2)

        numDocsAfter = messagesMachineManager.messagesConfiguration.count
        
        print("testLogin: test7_MessageConfigurationDelete num docs after and before: \(numDocsAfter) - \(numDocsBefore)")

        XCTAssertTrue(numDocsAfter == numDocsBefore-1)

    }

    
    
    
}

