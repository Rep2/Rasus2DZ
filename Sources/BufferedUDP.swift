//
//  SimulatedUDP.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class BufferedUDP{
    
    let socket:IRSocket
    
    init(socket: IRSocket){
        self.socket = socket
    }
    
    var outBuffer = [OutPacket]()
    
    func send(packet: OutPacket){
        
        outBuffer.append(packet)
        
        if Double(arc4random() % 1000) > (0.3 * 1000){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
 
                let delayTime = (Double(arc4random()) % (10000)) / 100000.0
                print("Send to port \(ntohs(packet.reciverNode.addr.cSockaddr.sin_port)) delayed \(delayTime)")
                
                usleep(UInt32(delayTime * 1000000.0))
                
                
                self.socket.sendTo(packet.reciverNode.addr, string: packet.toString())
            })
        }else{
            print("Send to port \(ntohs(packet.reciverNode.addr.cSockaddr.sin_port)) ommited")
        }
    }
    
    func recivedConformation(packet: ConformationPacket){
        
        for (index, outPacket) in outBuffer.enumerate(){
            if comparePackets(packet, outPacket: outPacket){
                outBuffer.removeAtIndex(index)
                break
            }
        }
        
    }
    
    func startResend(time: UInt32){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            repeat{
                usleep(time)
                
                self.resendBuffer()
            }while(true)
        })
    }
    
    func resendBuffer(){
        for packet in outBuffer{
            
            print("Resending value \(packet.value) to port \(ntohs(packet.reciverNode.addr.cSockaddr.sin_port))")
            send(packet)
            
        }
    }

}