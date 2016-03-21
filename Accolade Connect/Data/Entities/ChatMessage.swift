//
//  ChatMessage.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/20/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class ChatMessage: NSObject, JSQMessageData {
    
    private var _text: String
    private var _senderName: String
    private var _senderId: String
    private var _instant: NSDate
    private var _imageUrl: String?
    
    convenience init(text: String?, senderName: String?, senderId: String?, imageUrl: String?) {
        self.init(text: text, senderName: senderName, senderId: senderId, imageUrl: imageUrl, instant: NSDate())
    }
    
    init(text: String?, senderName: String?, senderId: String?, imageUrl: String?, instant: NSDate?) {
        _text = text!
        _senderId = senderId!
        _senderName = senderName!
        _instant = instant!
        _imageUrl = imageUrl
    }
    
    init(jsonDictionary: Dictionary<String, AnyObject>) {
        _text = jsonDictionary["text"] as! String!
        _senderId = jsonDictionary["senderId"] as! String!
        _senderName = jsonDictionary["senderName"] as! String!
        _instant = jsonDictionary["instant"] as! NSDate!
        if let imageUrl = jsonDictionary["imageUrl"] as! String? {
            _imageUrl = imageUrl
        }
    }
    
    func asDictionary() -> Dictionary<String, AnyObject> {
        var dictionary: Dictionary<String, AnyObject> = [ "text": _text, "senderId": _senderId, "senderName": _senderName]
        
        if let actualImageUrl = _imageUrl {
            dictionary["imageUrl"] = actualImageUrl
        }
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        dictionary["instant"] = formatter.stringFromDate(_instant)
        
        return dictionary
    }
    
    func text() -> String! {
        return _text
    }
    
    func senderId() -> String! {
        return _senderId
    }
    
    func senderDisplayName() -> String! {
        return _senderName
    }
    
    func date() -> NSDate! {
        return _instant
    }
    
    func imageUrl() -> String? {
        return _imageUrl
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func messageHash() -> UInt {
        return UInt(abs(_instant.hashValue))
    }
    
}
