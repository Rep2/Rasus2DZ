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
    
    var counter:Int = 0
    
    init(nodes:[Node], senzor:Senzor){
        
        self.nodes = nodes
        self.senzor = senzor
        
        if let sock = IRSocket(domain: AF_INET, type: SOCK_DGRAM, proto: 0){
            socket = sock
        }else{
            print("Klient socket creation failed")
            exit(1)
        }
        
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
                
                let str = (NSString(bytes: data, length: data.count, encoding: NSUTF8StringEncoding) as! String).characters.split{$0 == " "}.map(String.init)
                
                let time = Int(str[0])!
                let port = UInt16(str[2])!
                
                print("Recived conformation for \(time) from 127.0.0.1:\(port)")
            })

        }catch{
            print("Klient socket start failed")
            exit(1)
        }
    }
    
    func send(){
        
        let value = senzor.read()
        counter++;
        
        print("Read value \(value). Sending..")
        
        for node in nodes{
            
            // Store packet for conformation
            let packet = UDPPacket(value: value, node: node, time: counter, conformationAddr: conformationAddr)
        
            socket.sendTo(node.addr, string: packet.toString())
            
            
            /*SimulatedUDP.instance.sendTo(udpSocket, packet: packet)
            
            OutUDPBuffer.instance.requestBuffer.append(packet)
            
            var addr = sockaddr_in()
            let buffer:Array<UInt8> = Array(count: 100, repeatedValue: 0)
            var src_addr_len = socklen_t(16)
            
            print("Listening for conformation on port \(AppDelegate.instance.node.port)")
            
            let len = withUnsafeMutablePointer(&addr) {
                recvfrom(udpSocket , UnsafeMutablePointer<Void>(buffer), 100, 0, UnsafeMutablePointer($0), &src_addr_len)
            }
            */
            
        }
        
    }
    
}