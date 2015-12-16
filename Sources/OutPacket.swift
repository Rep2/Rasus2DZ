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
    let time:Double
    let vectorTime: [[String:AnyObject]]
    
    var conformationAddr: IRSockaddr
    
    func toString() -> String{
        
        return "\(value) \(time) 127.0.0.1 \(ntohs(conformationAddr.cSockaddr.sin_port)) \(JSON(vectorTime).rawString(NSUTF8StringEncoding)!)"
    }
    
    init(value:Int, node:Node, time:Double, vectorTime: [[String:AnyObject]], conformationAddr:IRSockaddr){
        self.value = value
        self.reciverNode = node
        
        self.time = time
        self.vectorTime = vectorTime
        
        self.conformationAddr = conformationAddr
    }
    
    
}

struct InPacket{
    
    let value:Int
    
    let time:Double
    let vectorTime: [[String:AnyObject]]
    
    var conformationAddr: IRSockaddr
    
    init(value:Int, time:Double, vectorTime: [[String:AnyObject]], conformationAddr:IRSockaddr){
        self.value = value
        
        self.time = time
        self.vectorTime = vectorTime
        
        self.conformationAddr = conformationAddr
    }
    
    static func fromString(string:String) -> InPacket{
        
   
        let data = string.characters.split{$0 == " "}.map(String.init)
     
       
        let jsonStringAsArray = data[4..<data.count].reduce("", combine: {$0 + $1})
        
        let jsondata: NSData = jsonStringAsArray.dataUsingEncoding(NSUTF8StringEncoding)!
        
        do{
            let anyObj: AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsondata, options: NSJSONReadingOptions(rawValue:0))
   
            return InPacket(value: Int(data[0])!, time: Double(data[1])!, vectorTime: anyObj as! [[String:AnyObject]] ,conformationAddr: IRSockaddr(ip: 0, port: UInt16(data[3])!, domain: 0))
    
        }catch{
            print("Failed to parse json")
        }
        
        return InPacket(value: Int(data[0])!, time: Double(data[1])!, vectorTime: [] ,conformationAddr: IRSockaddr(ip: 0, port: UInt16(data[3])!, domain: 0))
    }

    
}

struct ConformationPacket{

    let time:Double
    var senderAddr: IRSockaddr
    
    init(time:Double, senderAddr:IRSockaddr){
        self.time = time
        
        self.senderAddr = senderAddr
    }
    
    static func fromString(string:String) -> ConformationPacket{
        let data = string.characters.split{$0 == " "}.map(String.init)
        
        return ConformationPacket(time: Double(data[0])!, senderAddr: IRSockaddr(ip: 0, port: UInt16(data[2])!, domain: 0))
    }
}

func comparePackets(conformationPacket:ConformationPacket, outPacket: OutPacket) -> Bool{

    if (conformationPacket.time - outPacket.time) < 0.0000001 && conformationPacket.senderAddr.cSockaddr.sin_port == outPacket.reciverNode.addr.cSockaddr.sin_port{
        return true
    }else{
        return false
    }
    
}