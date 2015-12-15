//
//  Senzor.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

class Senzor{

    var inputData = [Int]()
    
    init(path:String){
        
        do{
            let data = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding).characters.split{$0 == "\n"}.map(String.init)
            
            for index in 1..<data.count{
                inputData.append(Int(data[index].characters.split{$0 == ","}.map(String.init)[3])!)
            }
        }catch{
            print("Failed to fetch data input file")
            exit(1)
        }
        print(inputData.count)
        
    }
    
    
    func read() -> Int{
        return inputData[Int(NSDate().timeIntervalSinceDate(AppDelegate.instance.startDate)) % 100]
    }
    
}