//
//  ClientMainController.swift
//  realtimechat
//
//  Created by Sean Overby on 3/1/16.
//  Copyright © 2016 Sean Overby. All rights reserved.
//

import UIKit
import Firebase

class ClientMainController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var haProfileImage: UIImageView!
    @IBOutlet weak var haProfileName: UILabel!
    @IBOutlet weak var haOnlineStatusImage: UIImageView!
    @IBOutlet weak var haOnlineStatusText: UILabel!
    @IBOutlet weak var chatHistory: UITextView!
    @IBOutlet weak var messageText: UITextField!
    
    var messageHistory = [String: String]()

    override func viewDidLoad() {
        messageText.delegate = self
        DataService.dataService.USER_PROFILE_REF.observeEventType(.Value, withBlock:self.observeHAProfile())
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let textToSend = "Sean: \(messageText.text!)"
        DataService.dataService.writeToRemoteHa(textToSend)
        chatHistory.text = chatHistory.text + "\n \(textToSend)"
        textField.text = ""
        chatHistory.scrollToBottom()
        return false
    }
    
    func observeHAMessageCenter() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            if let haDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let haProfile = HAProfile(dictionary: haDictionary)
                SessionManager.session[HA_PROFILE] = haProfile
                DataService.dataService.HA_MESSAGE_CENTER.childByAppendingPath("name").setValue("Sean Overby")
                self.processHAProfile(haProfile)
            }
        }
    }
    
    func observeHAProfile() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            DataService.dataService.HA_PROFILE_REF.observeEventType(.Value, withBlock: self.observeHAMessageCenter())
            DataService.dataService.MY_MESSAGE_CENTER.observeEventType(.Value,
                withBlock: DataService.dataService.observeMyMessageCenter(self.processNewMessageFunction()))
            print(" my message center: \(DataService.dataService.MY_MESSAGE_CENTER)")
        }
    }
    
    func processHAProfile(haProfile: HAProfile) {
        DataService.dataService.downloadImage(haProfile.pictureSrc, completionHandler: self.haProfileImageDownloaded())
        self.haProfileName.text = haProfile.friendlyName
        if(haProfile.isOnline) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.haOnlineStatusImage.image = UIImage(named: "onlineStatus")
                self.haOnlineStatusText.text = "Online"
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.haOnlineStatusImage.image = UIImage(named: "offlineStatus")
                self.haOnlineStatusText.text = "Offline"
            })
        }
    }
    
    func processNewMessageFunction() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print(snapshot.value)
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
                    }
                }
            })
        }
    }
    
    func haProfileImageDownloaded() -> ImageDownloadCompletionType {
        return { data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.haProfileImage.image = UIImage(data: data!)
            })
        }
    }
    

}

