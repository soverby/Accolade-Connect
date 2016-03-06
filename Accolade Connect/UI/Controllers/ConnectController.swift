//
//  ConnectController.swift
//  realtimechat
//
//  Created by Sean Overby on 3/1/16.
//  Copyright © 2016 Sean Overby. All rights reserved.
//

import UIKit
import Firebase

class ConnectController: UIViewController {
    
    @IBOutlet weak var haProfileImage: UIImageView!
    @IBOutlet weak var haProfileName: UILabel!
    @IBOutlet weak var haOnlineStatusImage: UIImageView!
    @IBOutlet weak var haOnlineStatusText: UILabel!
    
    func observeHAProfile() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            if let haDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let haProfile = HAProfile(dictionary: haDictionary)
                print(haProfile.firstName)
                print(haProfile.pictureSrc)
                SessionManager.session[HA_PROFILE] = haProfile
                self.processHAProfile(haProfile)
            }
        }
    }
    
    func observeClientProfile() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let userProfile = UserProfile(dictionary: postDictionary)
                print(userProfile.healthAssistantId)
                print(userProfile.isHA)
                SessionManager.session[USER_PROFILE] = userProfile
                DataService.dataService.HA_PROFILE_REF.observeEventType(.Value, withBlock: self.observeHAProfile())
            }
            
        }
    }
    
    override func viewDidLoad() {
        DataService.dataService.USER_PROFILE_REF.observeEventType(.Value, withBlock:self.observeClientProfile())
    }
    
    func processHAProfile(haProfile: HAProfile) {
        
    }
}

