//
//  UserProfile.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/2/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import Foundation

class UserProfile {
    
    private var _isHA: Bool!
    private var _healthAssistantId: String!
    
    var isHA: Bool {
        return _isHA
    }
    
    var healthAssistantId: String {
        return _healthAssistantId
    }
    
    init(dictionary: Dictionary<String, AnyObject>) {
        
        if let userIsHa = dictionary["isHA"] as? Bool {
            self._isHA = userIsHa
        }
        
        if let haid = dictionary["haid"] as? String {
            self._healthAssistantId = haid
        }
    }
}