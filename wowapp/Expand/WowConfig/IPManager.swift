//TODO  
////
////  IPManager.swift
////
////  Created by g on 16/8/5.
////  Copyright © 2016年 g. All rights reserved.
////
//
//import Foundation
//import EZSwiftExtensions
//
//class IPManager {
//    
//    static let sharedInstance = IPManager()
//    
//    fileprivate init() {
//        self.get_ip_public()
//    } //This prevents others from using the default '()' initializer for this class.
//    
//    var ip_public:String = ""
//   
//    // http://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift
//    func getIFAddresses() -> [String] {
//        var addresses = [String]()
//        
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
//        if getifaddrs(&ifaddr) == 0 {
//            
//            // For each interface ...
//            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
//                let flags = Int32(ptr.memory.ifa_flags)
//                var addr = ptr.memory.ifa_addr.memory
//                
//                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                        
//                        // Convert interface address to a human readable string:
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
//                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String(validatingUTF8: hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        return addresses
//    }
//    
//    // https://github.com/Weirdln/WBIphone/blob/master/Util/SystemInfoFunc/SystemInfoFunc.m
//    func getDataUsage() -> [UInt32] {
//        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
//        var networkData: UnsafeMutablePointer<if_data>! = nil
//        
//        var wifiDataSent:UInt32 = 0
//        var wifiDataReceived:UInt32 = 0
//        var wwanDataSent:UInt32 = 0
//        var wwanDataReceived:UInt32 = 0
//        
//        if getifaddrs(&ifaddr) == 0 {
//            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
//                
//                let name = String.fromCString(ptr.pointee.ifa_name)
//                let flags = Int32(ptr.memory.ifa_flags)
//                var addr = ptr.memory.ifa_addr.memory
//                
//                if addr.sa_family == UInt8(AF_LINK) {
//                    if name?.hasPrefix("en") == true {
//                        networkData = unsafeBitCast(ptr.memory.ifa_data, to: UnsafeMutablePointer<if_data>.self)
//                        wifiDataSent += networkData.pointee.ifi_obytes
//                        wifiDataReceived += networkData.pointee.ifi_ibytes
//                    }
//                    
//                    if name?.hasPrefix("pdp_ip") == true {
//                        networkData = unsafeBitCast(ptr.memory.ifa_data, to: UnsafeMutablePointer<if_data>.self)
//                        wwanDataSent += networkData.pointee.ifi_obytes
//                        wwanDataReceived += networkData.pointee.ifi_ibytes
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        
//        return [wifiDataSent, wifiDataReceived, wwanDataSent, wwanDataReceived]
//    }
//    
//    
//    
//    func get_ip_public() -> String {
//        var  ip_final  = ""
//        do {
//            let ipURL       = URL(string: "http://pv.sohu.com/cityjson?ie=utf-8")!
//            guard var  ip: String  = try! String(contentsOf: ipURL, encoding: String.Encoding.utf8) else { return "" }
//            
//            if ip.contains("var returnCitySN = ") {
//                //对字符串进行处理，只要后面json那段
//                ip = ip[ip.getIndexOf("=")!...ip.getIndexOf(";")!]
//
//                //将字符串转换成二进制进行Json解析
//                let data: Data = ip.data(using: String.Encoding.utf8)!
//                let dict: [String : String] = (try JSONSerialization.jsonObject(with: data, options:[])) as! [String : String]
//                
//                ip_final = dict["cip"]!
////                print(dict,ip_final)
//            }
//
//        }
//        catch let error {
////            print(error)
//            //若得不到外网ip地址 只能使用 本地ip地址
//            ip_final = self.getIFAddresses()[0]
//        }
//
//        if ( ip_final.length == 0 )  { ip_final = "127.0.0.1" }
//        
//        self.ip_public = ip_final
//        return ip_final
//    }
//    
//}
