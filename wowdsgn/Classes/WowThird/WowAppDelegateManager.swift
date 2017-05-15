import UIKit

public protocol WowAppDelegateProcotol{
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?)
    
}
public func ==(lhs: WowAppDelegateProcotol?, rhs: WowAppDelegateProcotol?) -> Bool
{
    if type(of: lhs) == type(of: rhs) {
        return true
    } else {
        return false
    }
}


public class WowAppDelegateManager  {
  
    public static let shared = WowAppDelegateManager()
    
    public var modules: [WowAppDelegateProcotol] = []
    
    public func loadModules(withPlistFile plistFile: String) {
        
    }
    
    public func all() -> [WowAppDelegateProcotol]{
        return self.modules
    }
    
    public func add(_ module: WowAppDelegateProcotol)
    {
        do {
            if ( modules.count > 0 ){
                for i in 0...modules.count {
                    if modules[i] == module {
                        DLog("同类型 module 已经有一个了 不能再次add! module name is \(module)")
                        return
                    }
                }
            }
            self.modules.append(module)

        } catch  {}
    }
    public func remove(_ module: WowAppDelegateProcotol) {
        for i in 0...modules.count {
            if modules[i] == module {
                modules.remove(at: i)
                return
            }
        }
    }
//    func loadModules(withPlistFile plistFile: String) {
//        var moduleNames = [Any](contentsOfFile: plistFile)
//        for moduleName: String in moduleNames {
//            weak var module = NSClassFromString(moduleName)()
//            self.add(module)
//        }
//    }
    public  func DLogAll() {
        for var e in self.modules {
            DLog("\(e)")
        }
    }


}


