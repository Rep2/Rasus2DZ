//
//  OutUDPBuffer.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class OutUDPBuffer{
    
    static let instance = OutUDPBuffer()
    
    var maxDelay = 0.5
    
    var requestBuffer = [OutPacket]()
    
    
    
}