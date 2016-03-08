//
//  ConnectController.swift
//  realtimechat
//
//  Created by Sean Overby on 3/1/16.
//  Copyright © 2016 Sean Overby. All rights reserved.
//

import UIKit
import Firebase

class ConnectController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var haProfileImage: UIImageView!
    @IBOutlet weak var haProfileName: UILabel!
    @IBOutlet weak var haOnlineStatusImage: UIImageView!
    @IBOutlet weak var haOnlineStatusText: UILabel!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var textEntry: UITextField!
    
    func observeHAProfile() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            print(snapshot)
            if let haDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let haProfile = HAProfile(dictionary: haDictionary)
                SessionManager.session[HA_PROFILE] = haProfile
                self.processHAProfile(haProfile)
            }
        }
    }
    
    func observeClientProfile() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let userProfile = UserProfile(dictionary: postDictionary)
                SessionManager.session[USER_PROFILE] = userProfile
                if !userProfile.isHA {
                    DataService.dataService.HA_PROFILE_REF.observeEventType(.Value, withBlock: self.observeHAProfile())
                }
            }
        }
    }
    
    func haProfileImageDownloaded() -> ImageDownloadCompletionType {
        return { data, response, error -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.haProfileImage.image = UIImage(data: data!)
            })
        }
    }
    
    override func viewDidLoad() {
        textEntry.delegate = self
        DataService.dataService.USER_PROFILE_REF.observeEventType(.Value, withBlock:self.observeClientProfile())
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        chatTextView.text = chatTextView.text + "\n Sean:" + textField.text!
        textField.text = ""
        let range = NSMakeRange(chatTextView.text.characters.count - 1, 1)
        chatTextView.scrollRangeToVisible(range)
        return false
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
}

