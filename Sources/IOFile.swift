//
//  IOFile.swift
//  RASUSLabos
//
//  Created by Rep on 12/13/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

extension NSData {
    
    func appendToRoute(fileRoute: String) {
        
        do{
            if let fileHandle = try? NSFileHandle(forWritingToURL: NSURL(fileURLWithPath: fileRoute)) {
                
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.writeData(self)
            }
                
            else {
                try writeToURL(NSURL(fileURLWithPath: fileRoute), options: .DataWritingAtomic)
            }
            
        }catch{
            print("Unable to append to file at url \(fileRoute)")
        }
    }
    
}