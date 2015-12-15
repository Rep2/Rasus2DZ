//
//  UDPServer.swift
//  RASUSLabos
//
//  Created by Rep on 12/13/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

/// Creates udp socket, binds it to random addr and listens on it
class UDPServer{
    
    let socket:IRSocket
    let addr:IRSockaddr
    
    init(){
        
        if let sock = IRSocket(domain: AF_INET, type: SOCK_DGRAM, proto: 0){
            socket = sock
        }else{
            print("Server socket creation failed")
            exit(1)
        }

        do{
            addr = IRSockaddr()
            try socket.bind(addr)
        
        
            "127.0.0.1 \(ntohs(addr.cSockaddr.sin_port))\n".dataUsingEncoding(NSUTF8StringEncoding)?.appendToRoute("config/nodes.txt")
            
            let socketReader = IRSocketReader(socket: socket)
            socketReader.read({
                (data: Array<UInt8>, addr: IRSockaddr) -> Void in
                
                let (value, time, senderAddr) = UDPPacket.fromString(NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding) as! String)
                Sorter.instance.packets.append(value)
                
                print("Recived value \(value) with time \(time) from 127.0.0.1:\(ntohs(senderAddr!.cSockaddr.sin_port)). Sending conformation.")
                
                self.socket.sendTo(senderAddr!, string: "\(time) 127.0.0.1 \(htons(addr.cSockaddr.sin_port))")
            })
            
            print("Node server listening on port \(ntohs(addr.cSockaddr.sin_port))")
            
        }catch{
            print("Server socket bind failed")
            exit(1)
        }
        
    }
    
}