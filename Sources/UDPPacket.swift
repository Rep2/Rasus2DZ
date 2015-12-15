//
//  UDPPacket.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

struct UDPPacket{
    
    let value:Int
    let reciverNode:Node
    let time:Int
    
    var conformationAddr: IRSockaddr?
    
    func toString() -> String{
        if conformationAddr == nil{
            return "\(value) \(time)"
        }else{
            return "\(value) \(time) 127.0.0.1 \(ntohs(conformationAddr!.cSockaddr.sin_port))"
        }
    }
    
    init(value:Int, node:Node, time:Int, conformationAddr:IRSockaddr? = nil){
        self.value = value
        self.reciverNode = node
        self.time = time
        
        self.conformationAddr = conformationAddr
    }
    
    static func fromString(string:String) -> (Int, Int, IRSockaddr?){
        let data = string.characters.split{$0 == " "}.map(String.init)
        
        if data.count == 1{
            return (Int(data[0])!, Int(data[1])!, nil)
        }else{
            return (Int(data[0])!, Int(data[1])!, IRSockaddr(ip: 0, port: UInt16(data[3])!, domain: 0))
        }
    }
}