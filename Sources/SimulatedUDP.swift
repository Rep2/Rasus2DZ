//
//  SimulatedUDP.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class SimulatedUDP{
    
    static let instance = SimulatedUDP(lossRate: 0.001, maxDelay: 10)
    
    let lossRate:Double
    let maxDelay:Double
    
    init(lossRate:Double, maxDelay:Double){
        self.lossRate = lossRate
        self.maxDelay = maxDelay
    }
    
    func sendTo(socket:Int32, packet:UDPPacket){
        if Double(arc4random() % 1000) > (lossRate * 1000){
            sleep(UInt32(Double(arc4random()) % maxDelay))
            
            sendTo(socket, packet: packet)
        }else{
            print("Packet ommited")
        }
    }
    
    func sendTo(socket:Int32, value:String, port:UInt16){
        if Double(arc4random() % 1000) > (lossRate * 1000){
            sleep(UInt32(Double(arc4random()) % maxDelay))
            
            sendTo(socket, value: value, port: port)
        }else{
            print("Packet ommited")
        }
    }
}