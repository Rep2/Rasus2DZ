//
//  UDPKlient.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

/// Creates udp client socket and sends read data to other nodes
/// Creates udp socket that recives data recived conformations
class UDPKlient{
    
    let socket: IRSocket
    
    let conformationSocket: IRSocket
    let conformationAddr: IRSockaddr
    
    let nodes:[Node]
    let senzor:Senzor
    
    let bufferedUDP:BufferedUDP
    
    init(nodes:[Node], senzor:Senzor){
        
        self.nodes = nodes
        self.senzor = senzor
        
        if let sock = IRSocket(domain: AF_INET, type: SOCK_DGRAM, proto: 0){
            socket = sock
        }else{
            print("Klient socket creation failed")
            exit(1)
        }
        
        bufferedUDP = BufferedUDP(socket: socket)
        
        if let sock = IRSocket(domain: AF_INET, type: SOCK_DGRAM, proto: 0){
            conformationSocket = sock
        }else{
            print("Klient conformation socket creation failed")
            exit(1)
        }
        
        do{
            
            conformationAddr = IRSockaddr()
            try conformationSocket.bind(conformationAddr)
            
            let socketReader = IRSocketReader(socket: conformationSocket)
            socketReader.read({
                (data: Array<UInt8>, addr: IRSockaddr) -> Void in
                
                let packet = ConformationPacket.fromString((NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding) as! String))
                
                print("Recived conformation for \(packet.time) from 127.0.0.1:\(ntohs(packet.senderAddr.cSockaddr.sin_port))")
                
                self.bufferedUDP.recivedConformation(packet)
                
            })
            
            bufferedUDP.startResend(7500000)

        }catch{
            print("Klient socket start failed")
            exit(1)
        }
        
         print("Client node started on port \(ntohs(conformationAddr.cSockaddr.sin_port))")
    }
    
    func send(){
        
        let value = senzor.read()
        let time = FalseTime.instance.getTime()
        
        print("Read value \(value) with time \(time). Sending..")
        
        VectorTime.instance.updateValue(time, port: Int(ntohs(AppDelegate.instance.server.addr.cSockaddr.sin_port)))
        
        Sorter.instance.addPacket(ValueWithTime(value: value, time: time, vectorTime: VectorTime.instance.nodesWithTime))
        
        for node in nodes{
         
            let packet = OutPacket(value: value, node: node, time: time, vectorTime: VectorTime.instance.nodesWithTime, conformationAddr: self.conformationAddr)
            bufferedUDP.send(packet)
            
            
        }
        
    }
    
}