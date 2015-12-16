//
//  Sorter.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class Sorter{
    
    static let instance = Sorter(delay: 25)
    
    init(delay: UInt32){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            self.sort(delay)
        })
        
    }
    
    var packets = [ValueWithTime]()
    
    func addPacket(packet:ValueWithTime){
        packets.append(packet)
    }
    
    
    func sort(delay: UInt32){
        repeat{
            sleep(delay)
            
            print("Sorting with scalar time")
            for str in packets.sort({$0.time < $1.time}).map({$0.toString()}){
                print(str)
            }
            
            let sortedByVector = packets.sort({
                (first: ValueWithTime, second: ValueWithTime) -> Bool in
                
                for node in first.vectorTime{
                    for secondNode in second.vectorTime{
                        if node["node"] as! Int == secondNode["node"] as! Int{
                            if node["time"] as! Double > secondNode["time"] as! Double{
                                return false
                            }
                            
                            break
                         }
                    }
                }
                
                return true
            })
            
            print("Sorting with vector time")
            for str in sortedByVector.map({$0.value}){
                print(str)
            }
            
            print("Avrege value: \(packets.reduce(0, combine: {$0 + $1.value}) / packets.count)")
            
            packets = []
        }while(true)
    }
    
    
}

struct ValueWithTime{

    let value: Int
    let time: Double
    
    let vectorTime: [[String:AnyObject]]
    
    func toString() -> String{
        return "\(value) \(time)"
    }
}