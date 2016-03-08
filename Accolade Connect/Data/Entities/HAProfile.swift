//
//  HAProfile.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/2/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import Foundation

class HAProfile {
    
    private var _firstName: String!
    private var _lastName: String!
    private var _friendlyName: String!
    private var _pictureSrc: String!
    private var _isOnline: Bool!
    
    var firstName: String {
        return _firstName
    }
    
    var lastName: String {
        return _lastName
    }
    
    var friendlyName: String {
        return _friendlyName
    }
    
    var pictureSrc: String {
        return _pictureSrc
    }
    
    var isOnline: Bool {
        return _isOnline
    }
    
    init(dictionary: Dictionary<String, AnyObject>) {
        if let actualizedFirstName = dictionary["firstName"] as? String {
            self._firstName = actualizedFirstName
        }
        
        if let actualizedLastName = dictionary["lastName"] as? String {
            self._lastName = actualizedLastName
        }
        
        if let actualizedFriendlyName = dictionary["friendlyName"] as? String {
            self._friendlyName = actualizedFriendlyName
        }
        
        if let actualizedImageSrc = dictionary["imgSrc"] as? String {
            self._pictureSrc = actualizedImageSrc
        }
        
        if let actualizedIsOnline = dictionary["isOnline"] as? String {
            self._isOnline = actualizedIsOnline == "true" ? true : false
        }
        
    }
}