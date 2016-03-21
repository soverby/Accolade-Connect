//
//  MessageController.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/20/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class MessageController: JSQMessagesViewController {
    
    var messageHistory = [String: ChatMessage]()
    var messages = [ChatMessage]()
    var avatars = Dictionary<String, UIImage>()
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = NSUUID().UUIDString
        automaticallyScrollsToMostRecentMessage = true
        self.setup()
        DataService.dataService.MY_MESSAGE_CENTER.observeEventType(.Value,
            withBlock: DataService.dataService.observeMyMessageCenter(self.processNewMessageFunction()))

    }
    
    func processNewMessageFunction() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print(snapshot.value)
                if let userList = snapshot.value as? Dictionary<String, AnyObject> {
                    for (key, value) in userList {
                        SessionManager.session[REMOTE_USER_ID] = key
                        if let messageDictionary = value["messages"] as? Dictionary<String, AnyObject> {
                            let newMessages = DataService.dataService.processChatMessages(self.messageHistory, newMessages: messageDictionary)
                            
                            for (newMsgKey, newMsgValue) in newMessages {
                                self.messageHistory[newMsgKey] = newMsgValue
                                self.messages.append(newMsgValue)
                            }
                            
                            self.reloadMessagesView()
                        }
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        // Clean up messages and other stuff we can dispose of.
    }
    
    func reloadMessagesView() {
        self.collectionView?.reloadData()
    }
    
    func setup() {
        self.senderId = SessionManager.session[USER_ID] as! String
        self.senderDisplayName = "Sean Overby"
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        let data = self.messages[indexPath.row]
        return data
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didDeleteMessageAtIndexPath indexPath: NSIndexPath!) {
        self.messages.removeAtIndex(indexPath.row)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let data = messages[indexPath.row]

        switch(data.senderId()) {
        case self.senderId:
            return self.outgoingBubble
        default:
            return self.incomingBubble
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = ChatMessage(text: text, senderName: senderDisplayName, senderId: senderId, imageUrl: nil)
        self.messages += [message]
        self.finishSendingMessage()
        
        let userProfile = SessionManager.session[USER_PROFILE] as! UserProfile
        
        if let isHA = userProfile.isHA {
            if(isHA) {
                DataService.dataService.writeToRemoteUser(message)
            } else {
                DataService.dataService.writeToRemoteHa(message)
            }
        } else {
            print(" failed....")
        }

    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        
    }
}