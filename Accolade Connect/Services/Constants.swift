//
//  Constants.swift
//  realtimechat
//
//  Created by Sean Overby on 3/1/16.
//  Copyright © 2016 Sean Overby. All rights reserved.
//

import Foundation
import Firebase

// Global Typealiases

// Firebase Observe Event type
typealias FirebaseObserveEventType = (snapshot: FDataSnapshot!) -> Void

// Firebase Create User type
typealias FirebaseCreateUserType = (error: NSError?, dictionary: Dictionary<String, String>) -> Void

// Basic no param void type
typealias NoParamVoidType = () -> Void

// Async Image download type
typealias ImageDownloadCompletionType = (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void


let BASE_URL = "https://accolade-connect.firebaseio.com/"



