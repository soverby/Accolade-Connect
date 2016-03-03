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
    }
}

