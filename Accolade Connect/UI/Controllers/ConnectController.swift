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
    
    @IBOutlet weak var tempLabel: UILabel!
    
    override func viewDidLoad() {
        tempLabel.text = SessionManager.session[USER_ID]
        
        print(DataService.dataService.USER_PROFILE_REF)
        DataService.dataService.USER_PROFILE_REF.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let userProfile = UserProfile(dictionary: postDictionary)
                print(userProfile.healthAssistantId)
                print(userProfile.isHA)
            }
            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                for snap in snapshots {
//                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let userProfile = UserProfile(dictionary: postDictionary)
//                        print(userProfile.healthAssistantId)
//                        print(userProfile.isHA)
//                    }
//                }
//            }
        })
    }
}

