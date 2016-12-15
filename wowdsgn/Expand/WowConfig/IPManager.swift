

import Foundation

class IPManager {
    
    static let sharedInstance = IPManager()
    
    fileprivate init() {
        self.get_ip_public()
    }
    
    var ip_public:String = ""
   
    // http://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getIPAddress() -> [String]? {
        var address : String?
        var IPAddressArray:[String] = [String]()
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Convert interface address to a human readable string:
                var addr = interface.ifa_addr.pointee
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
                IPAddressArray.append(address!)
            }
        }
        freeifaddrs(ifaddr)
        
        return IPAddressArray
    }
    
    func get_ip_public() -> String {
        var  ip_final  = ""
        do {
            let ipURL               = URL(string: "https://pv.sohu.com/cityjson?ie=utf-8")!
            var ip                  = try! String(contentsOf: ipURL, encoding: String.Encoding.utf8)
            
            if ip.contains("var returnCitySN = ") {
                //对字符串进行处理，只要后面json那段
                ip = ip[ip.getIndexOf("{")!...ip.getIndexOf("}")!]

                //将字符串转换成二进制进行Json解析
                let data: Data = ip.data(using: String.Encoding.utf8)!
                let dict: [String : String] = (try JSONSerialization.jsonObject(with: data, options:[])) as! [String : String]
                
                ip_final = dict["cip"] ?? ""
                print(dict,ip_final)
            }

        }
        catch _ {
//            print(error)
            //若得不到外网ip地址 只能使用 本地ip地址
            if let tmp = self.getIPAddress()?[0]{
                ip_final = "192.168.1.1"
            }
        }
        
        if ( ip_final.length == 0 )  { ip_final = "127.0.0.1" }
        
        self.ip_public = ip_final
        return ip_final
    }
    
}
