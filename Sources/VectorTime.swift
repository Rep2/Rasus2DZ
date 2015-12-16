//
//  VectorTime.swift
//  RASUSLabos
//
//  Created by Rep on 12/16/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation


class VectorTime {
    
    static var instance:VectorTime!
    
    var nodesWithTime = [[String:AnyObject]]()
    
    init(nodes: [Node]){
        for node in nodes{
            
            let nodeWithTime:[String:AnyObject] = [
                "node": Int(ntohs(node.addr.cSockaddr.sin_port)),
                "time": 0
            ]
            
            nodesWithTime.append(nodeWithTime)
        }
        
        VectorTime.instance = self
    }
    
    func toString() -> String{
        return JSON(nodesWithTime).stringValue
    }
    
    func updateValue(value:Double, port:Int){
        for (index, node) in nodesWithTime.enumerate(){
            if node["node"] as! Int == port{
                nodesWithTime.removeAtIndex(index)
                break
            }
        }
        
        nodesWithTime.append([
            "node": port,
            "time": value
            ])
    }
    
    func updateAll(vectorTime: [[String:AnyObject]]){
  
        var newNodes = [[String:AnyObject]]()
   
        outer:
            for node in vectorTime{
                for oldNode in nodesWithTime{
                    if node["node"] as! Int == oldNode["node"] as! Int{
                        newNodes.append([
                            "node": node["node"] as! Int,
                            "time": node["time"] as! Double > oldNode["time"] as! Double ? node["time"] as! Double : oldNode["time"] as! Double
                            ])
                        continue outer
                    }
                }
                
                newNodes.append([
                    "node": node["node"] as! Int,
                    "time": node["time"] as! Double
                    ])
        }
        
        nodesWithTime = newNodes
    }
    
    
}

