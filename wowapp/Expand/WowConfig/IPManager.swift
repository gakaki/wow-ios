//
//  IPManager.swift
//
//  Created by g on 16/8/5.
//  Copyright © 2016年 g. All rights reserved.
//

import Foundation
import SwiftString

class IPManager {
    
    static let sharedInstance = IPManager()
    
    private init() {
        self.get_ip_public()
    } //This prevents others from using the default '()' initializer for this class.
    
    var ip_public:String = ""
   
    // http://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
    // https://github.com/Weirdln/WBIphone/blob/master/Util/SystemInfoFunc/SystemInfoFunc.m
    func getDataUsage() -> [UInt32] {
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        var networkData: UnsafeMutablePointer<if_data>! = nil
        
        var wifiDataSent:UInt32 = 0
        var wifiDataReceived:UInt32 = 0
        var wwanDataSent:UInt32 = 0
        var wwanDataReceived:UInt32 = 0
        
        if getifaddrs(&ifaddr) == 0 {
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                
                let name = String.fromCString(ptr.memory.ifa_name)
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                if addr.sa_family == UInt8(AF_LINK) {
                    if name?.hasPrefix("en") == true {
                        networkData = unsafeBitCast(ptr.memory.ifa_data, UnsafeMutablePointer<if_data>.self)
                        wifiDataSent += networkData.memory.ifi_obytes
                        wifiDataReceived += networkData.memory.ifi_ibytes
                    }
                    
                    if name?.hasPrefix("pdp_ip") == true {
                        networkData = unsafeBitCast(ptr.memory.ifa_data, UnsafeMutablePointer<if_data>.self)
                        wwanDataSent += networkData.memory.ifi_obytes
                        wwanDataReceived += networkData.memory.ifi_ibytes
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return [wifiDataSent, wifiDataReceived, wwanDataSent, wwanDataReceived]
    }
    
    
    
    func get_ip_public() -> String {
        var  ip_final  = ""
        do {
            let ipURL       = NSURL(string: "http://pv.sohu.com/cityjson?ie=utf-8")!
            guard var  ip: String  = try! String(contentsOfURL: ipURL, encoding: NSUTF8StringEncoding) else { return "" }
            
            if ip.contains("var returnCitySN = ") {
                //对字符串进行处理，只要后面json那段
                ip = ip.between("=", ";")!
                
                //将字符串转换成二进制进行Json解析
                let data: NSData = ip.dataUsingEncoding(NSUTF8StringEncoding)!
                let dict: [String : String] = (try NSJSONSerialization.JSONObjectWithData(data, options:[])) as! [String : String]
                
                ip_final = dict["cip"]!
//                print(dict,ip_final)
            }

        }
        catch let error {
//            print(error)
            //若得不到外网ip地址 只能使用 本地ip地址
            ip_final = self.getIFAddresses()[0]
        }

        if ( ip_final.isEmpty() )  { ip_final = "127.0.0.1" }
        
        self.ip_public = ip_final
        return ip_final
    }
    
}