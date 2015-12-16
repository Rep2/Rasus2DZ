//
//  ProgrammErrors.swift
//  RASUSLabos
//
//  Created by Rep on 12/13/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class AppDelegate{

    static var instance:AppDelegate!
    
    var pathToNodesFile = "config/nodes.txt"
    var pathToInputFile = "config/mjerenja.csv"
    let startDate = NSDate()
    
    let server:UDPServer
    
    init(){
        
        for (index, argument) in Process.arguments.enumerate() {
      
            switch argument{
            case "-c":
                if Process.arguments.count < (index + 2){
                    failWithInstructions()
                }
            
                pathToNodesFile = Process.arguments[index + 1]
            default:
                break
            }
        
        }
        
        // Start server socket
        server = UDPServer()
        
        AppDelegate.instance = self
        
        
        print("Press a key to connect nodes and start process")
        
        let _ = readLine(stripNewline: true)
    
        // Fetches server nodes
        let serverNodes = ServerNodesReader (path: pathToNodesFile)
        
        // Starts senzor
        let senzor = Senzor(path: pathToInputFile)
        
        // Starts klient
        let klient = UDPKlient(nodes: serverNodes.nodes, senzor: senzor)
        
        repeat{
            klient.send()
            sleep(5)
        }while(true)
        
    }
    
}

func failWithInstructions(){
    print("Incorect programm call. Try:")
    print(".RASUSLabos [-c <path_to_config_file>]")
    exit(1)
}