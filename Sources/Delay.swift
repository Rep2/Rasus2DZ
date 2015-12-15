//
//  Delay.swift
//  Glaxo
//
//  Created by IN2 MacbookPro on 03/12/15.
//  Copyright © 2015 IN2. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}