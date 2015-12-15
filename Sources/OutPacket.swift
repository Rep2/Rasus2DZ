//
//  UDPPacket.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

struct OutPacket{
    
    let value:Int
    let reciverNode:Node
    let time:Int
    
    var conformationAddr: IRSockaddr
    
    func toString() -> String{
        return "\(value) \(time) 127.0.0.1 \(ntohs(conformationAddr.cSockaddr.sin_port))"
    }
    
    init(value:Int, node:Node, time:Int, conformationAddr:IRSockaddr){
        self.value = value
        self.reciverNode = node
        self.time = time
        
        self.conformationAddr = conformationAddr
    }
    
    
}

struct InPacket{
    
    let value:Int
    let time:Int
    
    var conformationAddr: IRSockaddr
    
    init(value:Int, time:Int, conformationAddr:IRSockaddr){
        self.value = value
        self.time = time
        
        self.conformationAddr = conformationAddr
    }
    
    static func fromString(string:String) -> InPacket{
        let data = string.characters.split{$0 == " "}.map(String.init)
   
        return InPacket(value: Int(data[0])!, time: Int(data[1])!, conformationAddr: IRSockaddr(ip: 0, port: UInt16(data[3])!, domain: 0))
    }

    
}

struct ConformationPacket{

    let time:Int
    var senderAddr: IRSockaddr
    
    init(time:Int, senderAddr:IRSockaddr){
        self.time = time
        
        self.senderAddr = senderAddr
    }
    
    static func fromString(string:String) -> ConformationPacket{
        let data = string.characters.split{$0 == " "}.map(String.init)
        
        return ConformationPacket(time: Int(data[0])!, senderAddr: IRSockaddr(ip: 0, port: UInt16(data[2])!, domain: 0))
    }
}

func comparePackets(conformationPacket:ConformationPacket, outPacket: OutPacket) -> Bool{

    if conformationPacket.time == outPacket.time && conformationPacket.senderAddr.cSockaddr.sin_port == outPacket.reciverNode.addr.cSockaddr.sin_port{
 
        return true
    }else{
    
        return false
    }
    
}