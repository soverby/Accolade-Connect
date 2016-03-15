//
//  UITextView+Utility.swift
//  Accolade Connect
//
//  Created by Sean Overby on 3/8/16.
//  Copyright © 2016 Accolade. All rights reserved.
//

import UIKit

extension UITextView {
    
    func scrollToBottom() {
        let range = NSMakeRange(text.characters.count - 1, 1);
        scrollRangeToVisible(range);
    }
    
}
