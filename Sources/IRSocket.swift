//
//  IRSocket.swift
//  RASUSLabos
//
//  Created by Rep on 12/14/15.
//  Copyright © 2015 Rep. All rights reserved.
//

import Foundation

enum IRSocketError: ErrorType{
    case BindFailed(error: Int32)
    case CloseFailed(error: Int32)
    case GetNameFailed(error: Int32)
}

/// Basic C socket binding
class IRSocket{
    
    /// C socket
    let cSocket:Int32
    
    /// Creates new instance of IRSocket containing C socket
    /// - Returns: IRSocket nil if creation fails
    init?(domain:Int32, type:Int32, proto:Int32){
        cSocket = socket(domain, type, proto)
        
        if cSocket == -1{
            return nil
        }
    }
    
    
    /// Binds socket to addres and updates address
    /// - Parameter addr: Binding address
    /// - Parameter update: If set updates addr fields
    ///
    /// - Throws: IRSocketError
    func bind(addr:IRSockaddr, update:Bool = true) throws{
        
        let bindRet = withUnsafePointer(&addr.cSockaddr) {
            bind(cSocket, UnsafePointer<sockaddr>($0), 16)
        }
        
        if bindRet != 0{
            throw IRSocketError.BindFailed(error: bindRet)
        }
        
        if update{
            try getName(addr)
        }
        
    }
    
    
    /// Updates addr to correct value
    /// - Parameter addr: Binding address
    ///
    /// - Throws: IRSocketError
    func getName(addr:IRSockaddr) throws{
        var src_addr_len = socklen_t(sizeofValue(socket))
        
        let err = withUnsafePointer(&addr.cSockaddr) {
            return getsockname(self.cSocket, UnsafeMutablePointer($0), &src_addr_len)
        }
        
        if err == -1{
            throw IRSocketError.GetNameFailed(error: err)
        }

    }
    
    
    /// Recives data from socket and returns it unmodified
    /// If no data is available call waits for message to arive
    ///
    /// - Parameter maxLen: maximum data length in bytes
    /// - Parameter flag: check http://linux.die.net/man/2/recvfrom
    /// - Return: recived byte array
    func recive(maxLen: Int = 500, flag: Int32 = 0) -> Array<UInt8>{
        let buffer = Array<UInt8>(count: maxLen, repeatedValue: 0)
        
        let count = recv(cSocket, UnsafeMutablePointer<Void>(buffer), maxLen, flag)
        
        return Array(buffer[0..<count])
    }
    
    
    /// Recives data from socket and returns it unmodified toghether with sender address
    /// If no data is available call waits for message to arive
    ///
    /// - Parameter maxLen: maximum data length in bytes
    /// - Parameter flag: check http://linux.die.net/man/2/recvfrom
    /// - Return: recived byte array and sender address
    func reciveAndStoreAddres(maxLen: Int = 500, flag: Int32 = 0) -> (Array<UInt8>, IRSockaddr){
        let buffer:Array<UInt8> = Array(count: maxLen, repeatedValue: 0)
        
        var sockLen = socklen_t(16)
        var addr = sockaddr_in()

        let count = withUnsafeMutablePointer(&addr) {
            recvfrom(cSocket , UnsafeMutablePointer<Void>(buffer), maxLen, flag, UnsafeMutablePointer($0), &sockLen)
        }
        
        return (Array(buffer[0..<count]), IRSockaddr(socket: addr))
    }
    
    
    func sendTo(addr:IRSockaddr, string:String){
        
        string.withCString { cstr -> Void in
            withUnsafePointer(&addr.cSockaddr) { ptr -> Void in
                let addrptr = UnsafePointer<sockaddr>(ptr)
                
                sendto(cSocket, cstr, string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding), 0, addrptr, socklen_t(addr.cSockaddr.sin_len))
            }
        }
        
    }
 
    
    /// Closes socket
    deinit{
        close(cSocket)
    }
}