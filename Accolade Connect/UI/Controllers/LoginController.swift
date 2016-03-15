//
//  ViewController.swift
//  realtimechat
//
//  Created by Sean Overby on 1/31/16.
//  Copyright © 2016 Sean Overby. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!

    var userProfileHandle: UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "MainBackground")
    }

    override func viewDidAppear(animated: Bool) {
        if let _ = SessionManager.session[USER_ID] {
            self.performSegueWithIdentifier("loggedInSegue", sender: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAction(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        
        if email != "" && password != "" {
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error != nil {
                    print(error)
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                } else {
                    SessionManager.session[USER_ID] = authData.uid
                    self.userProfileHandle = DataService.dataService.USER_PROFILE_REF.observeEventType(.Value, withBlock:self.observeMyUserProfile())
                }
            })
            
        } else {
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
        }
    }

    func loginErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func observeMyUserProfile() -> FirebaseObserveEventType {
        return { snapshot -> Void in
            if let postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let userProfile = UserProfile(dictionary: postDictionary)
                SessionManager.session[USER_PROFILE] = userProfile
                DataService.dataService.USER_PROFILE_REF.removeObserverWithHandle(self.userProfileHandle)
            
                if let isHA = userProfile.isHA {
                    if(isHA) {
                        self.performSegueWithIdentifier("HALoggedInSegue", sender: nil)
                    } else {
                        self.performSegueWithIdentifier("clientLoggedInSegue", sender: nil)
                    }
                } else {
                    self.loginErrorAlert("Fail!", message: "Data fail! userProfile isHA is null")
                }
            }
        }
    }
    
}

