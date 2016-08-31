
import UIKit
import JSPatch

class JSPatchHelper:NSObject{
    
    dynamic static func root_vc_change(vc_name:String = "JPDemoController"){

        let ns = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as! String
        let anyobjecType: AnyObject.Type = NSClassFromString(ns + "." + vc_name)!
        var vc:UIViewController
        if anyobjecType is UIViewController.Type {
            vc = (anyobjecType as! UIViewController.Type).init()
            print(vc)
        }else{
            vc = UIViewController()
        }
        
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            window.rootViewController = vc
        }

    }
    
    dynamic static func testVC(){
        
        let vcName =  "VCSceneCategory"
        root_vc_change(vcName)

    }
    
    dynamic static func jspatch_playground(){
        
        JPEngine.startEngine()
        let jspathEngineFile     = NSBundle.mainBundle().pathForResource("demo", ofType: "js")
        JPEngine.evaluateScriptWithPath(jspathEngineFile)
        
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            let stopwatch = Stopwatch()
            
            let mainScriptPath      = "/Users/g/Desktop/work/wow-ios/wowapp/Resource/JSPatchCode/demo.js"
            
            JPPlayground.setReloadCompleteHandler({
//                self.testVC()
            })
            JPPlayground.startPlaygroundWithJSPath(mainScriptPath)
            
            print("jspatch elapsed time: \(stopwatch.elapsedTimeString())")
        #endif
        
    }
    
    dynamic func jspatch_init(){
        
        //        JSPatch.startWithAppKey("df0431d2643f2f41")
        //        JSPatch.setupCallback { (type, data, error) in
        //            print(type)
        //            print(data)
        //        }
        //
        //        #if DEBUG
        //            JSPatch.setupDevelopment()
        //            JSPatch
        //        
        //        #else
        //
        //        #endif
        //        JSPatch.sync()
    }

    
}
