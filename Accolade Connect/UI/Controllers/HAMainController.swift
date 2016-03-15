//
//  HAMainController.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/11/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import UIKit
import Firebase

class HAMainController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var chatHistory: UITextView!
    
    var messageHistory = [String: String]()
    
    func processNewMessageFunction() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let userList = snapshot.value as? Dictionary<String, AnyObject> {
                    for (key, value) in userList {
                        SessionManager.session[REMOTE_USER_ID] = key
                        if let messageDictionary = value["messages"] as? Dictionary<String, String> {
                            let messages = DataService.dataService.processMessages(self.messageHistory, newMessages: messageDictionary)
                            
                            for message in messages {
                                self.chatHistory.text = self.chatHistory.text + "\n \(message)"
                            }
                            
                            self.messageHistory = messageDictionary
                        }
                        break
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        messageText.delegate = self
        print(DataService.dataService.MY_MESSAGE_CENTER)
        DataService.dataService.MY_MESSAGE_CENTER.observeEventType(.Value,
            withBlock: DataService.dataService.observeMyMessageCenter(processNewMessageFunction()))
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let textToSend = "Marie: \(messageText.text!)"
        DataService.dataService.writeToRemoteUser(textToSend)
        chatHistory.text = chatHistory.text + "\n \(textToSend)"
        textField.text = ""
        chatHistory.scrollToBottom()
        return false
    }
}
