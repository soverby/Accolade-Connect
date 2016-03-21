//
//  DataProcessorTests.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/20/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import XCTest
@testable import Accolade_Connect

class DataProcessorTests: XCTestCase {

    let testText = "Test text"
    let senderId = NSUUID().UUIDString
    let senderName = "Sean O"
    let instant = NSDate()
    let imageUrl = "http://www.overtherainbow.com"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        DataService.dataService.processChat
    }

    func testProcessJsonIntoChatMessage() {
        var testDictionary = [String: AnyObject]()
        testDictionary["text"] = testText
        testDictionary["senderId"] = senderId
        testDictionary["senderName"] = senderName
        testDictionary["instant"] = instant
        testDictionary["imageUrl"] = imageUrl
        
        let message = ChatMessage(jsonDictionary: testDictionary)
        
        XCTAssertEqual(message.text(), testText)
        XCTAssertEqual(message.senderId(), senderId)
        XCTAssertEqual(message.senderDisplayName(), senderName)
        XCTAssertEqual(message.date(), instant)
        XCTAssertEqual(message.imageUrl(), imageUrl)
    }
    
    func testProcessChatMessageIntoJson() {
        let message = ChatMessage(text: testText, senderName: senderName, senderId: senderId, imageUrl: imageUrl, instant: instant)
        
        let messageDictionary = message.asDictionary()
        
        if let actualText = messageDictionary["text"] as? String,
                actualSenderId = messageDictionary["senderId"] as? String,
                actualSenderName = messageDictionary["senderName"] as? String,
                actualInstant = messageDictionary["instant"] as? NSDate,
                actualImageUrl = messageDictionary["imageUrl"] as? String {
            XCTAssertEqual(actualText, testText)
            XCTAssertEqual(actualSenderId, senderId)
            XCTAssertEqual(actualSenderName, senderName)
            XCTAssertEqual(actualInstant, instant)
            XCTAssertEqual(actualImageUrl, imageUrl)
        } else {
            XCTFail()
        }
    }
    
    func testProcessChatMessages() {
        var messageHistory = [String: ChatMessage]()
        var newMessages = [String: AnyObject]()
        
        var idArray = [String]()
        
        for _ in 0..<4 {
            idArray.append(NSUUID().UUIDString)
        }
        
        for i in 0..<3 {
            let message = ChatMessage(text: "\(testText)\(i)", senderName: senderName, senderId: senderId, imageUrl: imageUrl)
            messageHistory[idArray[i]] = message
            newMessages[idArray[i]] = message.asDictionary()
        }
        
        let message = ChatMessage(text: "\(testText)4", senderName: senderName, senderId: senderId, imageUrl: imageUrl)
        newMessages[idArray[3]] = message.asDictionary()
        
        let processedMessages = DataService.dataService.processChatMessages(messageHistory, newMessages: newMessages)
        
        XCTAssert(processedMessages.count == 1)
        
        for (key, value) in processedMessages {
            XCTAssertEqual(key, idArray[3])
            XCTAssertEqual(value.text(), "\(testText)4")
        }
    }
    
}
