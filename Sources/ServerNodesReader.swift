//
//  ConnectToNodes.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class ServerNodesReader {
    
    let nodes:[Node]
    
    init(path:String){
        do{
            nodes =  Node.createNodesFromText(try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)).filter({$0.addr.cSockaddr.sin_port != AppDelegate.instance.server.addr.cSockaddr.sin_port})
        }catch{
            print("Failed to fetch node list")
            exit(1)
        }
    }
}
