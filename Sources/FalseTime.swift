//
//  Time.swift
//  RASUSLabos
//
//  Created by Rep on 12/16/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class FalseTime{
    
    static let instance = FalseTime()

    let startTime = NSDate()
    let falseSecond:Double
    
    init(falseSecond:Double? = nil){
    
        if let falseSecond = falseSecond{
            self.falseSecond = falseSecond
        }else{
            self.falseSecond = Double(arc4random() % UInt32(2000000)) / 1000000.0
        }
    }
    
    func getTime() -> Double{
        
        let realTime = NSDate().timeIntervalSinceDate(startTime)
        
        return realTime / falseSecond
    }
    
}