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
                (data: Array<UInt8>, senderAddr: IRSockaddr) -> Void in
                
                let packet = InPacket.fromString(NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding) as! String)
                
                print("Recived value \(packet.value) with time \(packet.time) from 127.0.0.1:\(ntohs(packet.conformationAddr.cSockaddr.sin_port)). Sending conformation.")
          
                
                if Double(arc4random() % 1000) > (0.001 * 1000){
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                        
                        let delayTime = (Double(arc4random()) % (10000)) / 100000.0
                        print("Conformation to port \(ntohs(packet.conformationAddr.cSockaddr.sin_port)) delayed \(delayTime)")
                        
                        usleep(UInt32(delayTime * 1000000.0))
                        
                        
                        self.socket.sendTo(packet.conformationAddr, string: "\(packet.time) 127.0.0.1 \(ntohs(self.addr.cSockaddr.sin_port))")
                    })
                }else{
                    print("Conformation to port \(ntohs(packet.conformationAddr.cSockaddr.sin_port)) ommited")
                }
                
            })
            
            print("Node server listening on port \(ntohs(addr.cSockaddr.sin_port))")
            
        }catch{
            print("Server socket bind failed")
            exit(1)
        }
        
    }
    
}