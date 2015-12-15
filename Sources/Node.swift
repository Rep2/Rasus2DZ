//
//  Node.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

struct Node{
    
    var addr: IRSockaddr
    
    init(port: UInt16, ip: UInt32){
        addr = IRSockaddr(ip: ip, port: port, domain: 0)
    }
    
    static func createNodesFromText(text:String) -> [Node]{
        
        let data = text.characters.split{$0 == "\n"}.map(String.init)
        
        var nodes = [Node]()
        for entity in data{
            nodes.append(createNodeFromText(entity))
        }
        
        return nodes
    }
    
    static func createNodeFromText(text:String) -> Node{
        let data = text.characters.split{$0 == " "}.map(String.init)
        
        return Node(port: UInt16(data[1])!, ip: 0)
    }
}
