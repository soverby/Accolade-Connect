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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                    self.performSegueWithIdentifier("loggedInSegue", sender: nil)
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
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
}

