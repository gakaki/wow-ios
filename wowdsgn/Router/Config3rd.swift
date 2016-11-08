

import Foundation


struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

public struct  Config3rd {
    
    public static let umessage_app_key              = "57146c72e0f55a807e000a0b"
    public static let umessage_app_master_secret    = "birwz9idofxnmcwivj0u68ys4iy4wjoc"
    
    public static let jpush_app_key                 = "65be8230264cfed423a865ac"
    public static let jpush_app_master_secret       = "fdaaeb2476f04db1adc750d7"
    public static let jpush_channel                 = "Publish channel"
    public static let jpush_is_production           = false
    
    
}

