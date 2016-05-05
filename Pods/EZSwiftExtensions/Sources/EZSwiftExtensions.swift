//
//  EZSwiftExtensions.swift
//  EZSwiftExtensions
//
//  Created by Goktug Yilmaz on 13/07/15.
//  Copyright (c) 2015 Goktug Yilmaz. All rights reserved.
//
import UIKit

//TODO: others standart video, gif

public struct ez {

    /// EZSE: Returns app's name
    public static var appDisplayName: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName") as? String
            ?? NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
    }

    /// EZSE: Returns app's version number
    public static var appVersion: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }

    /// EZSE: Return app's build number
    public static var appBuild: String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }

    /// EZSE: Returns both app's version and build numbers "v0.3(7)"
    public static var appVersionAndBuild: String {
        let version = appVersion, build = appBuild
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }

    /// EZSE: Returns the top ViewController
    public static var topMostVC: UIViewController? {
        var presentedVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }

        if presentedVC == nil {
            print("EZSwiftExtensions Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
        }
        return presentedVC
    }

    /// EZSE: Returns current screen orientation
    public static var screenOrientation: UIInterfaceOrientation {
        return UIApplication.sharedApplication().statusBarOrientation
    }
  
    /// EZSwiftExtensions
    public static var horizontalSizeClass : UIUserInterfaceSizeClass {
      return self.topMostVC?.traitCollection.horizontalSizeClass ?? UIUserInterfaceSizeClass(rawValue: 0)!
    }
  
    /// EZSwiftExtensions
    public static var verticalSizeClass : UIUserInterfaceSizeClass {
      return self.topMostVC?.traitCollection.verticalSizeClass ?? UIUserInterfaceSizeClass(rawValue: 0)!
    }

    /// EZSE: Returns screen width
    public static var screenWidth: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.mainScreen().bounds.size.width
        } else {
            return UIScreen.mainScreen().bounds.size.height
        }
    }

    /// EZSE: Returns screen height
    public static var screenHeight: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.mainScreen().bounds.size.height
        } else {
            return UIScreen.mainScreen().bounds.size.width
        }
    }

    /// EZSE: Returns StatusBar height
    public static var screenStatusBarHeight: CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }

    /// EZSE: Return screen's height without StatusBar
    public static var screenHeightWithoutStatusBar: CGFloat {
        if UIInterfaceOrientationIsPortrait(screenOrientation) {
            return UIScreen.mainScreen().bounds.size.height - screenStatusBarHeight
        } else {
            return UIScreen.mainScreen().bounds.size.width - screenStatusBarHeight
        }
    }

    /// EZSE: Calls action when a screen shot is taken
    public static func detectScreenShot(action: () -> ()) {
        let mainQueue = NSOperationQueue.mainQueue()
        NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationUserDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            // executes after screenshot
            action()
        }
    }

    // MARK: - Dispatch


    /// EZSE: Runs function after x seconds
    public static func runThisAfterDelay(seconds seconds: Double, after: () -> ()) {
        runThisAfterDelay(seconds: seconds, queue: dispatch_get_main_queue(), after: after)
    }

    //TODO: Make this easier
    /// EZSE: Runs function after x seconds with dispatch_queue, use this syntax: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    public static func runThisAfterDelay(seconds seconds: Double, queue: dispatch_queue_t, after: ()->()) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(time, queue, after)
    }

    /// EZSE: Submits a block for asynchronous execution on the main queue
    public static func runThisInMainThread(block: dispatch_block_t) {
        dispatch_async(dispatch_get_main_queue(), block)
    }

    /// EZSE: Runs in Default priority queue
    public static func runThisInBackground(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    /// EZSE: Runs every second, to cancel use: timer.invalidate()
    public static func runThisEvery(seconds seconds: NSTimeInterval, startAfterSeconds: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = startAfterSeconds + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, seconds, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }

    // MARK: - DownloadTask

    /// EZSE: Downloads image from url string
    public static func requestImage(url: String, success: (UIImage?) -> Void) {
        requestURL(url, success: { (data) -> Void in
            if let d = data {
                success(UIImage(data: d))
            }
        })
    }

    /// EZSE: Downloads JSON from url string
    public static func requestJSON(url: String, success: (AnyObject? -> Void), error: ((NSError) -> Void)?) {
        requestURL(url,
            success: { (data)->Void in
                let json: AnyObject? = self.dataToJsonDict(data)
                success(json)
            },
            error: { (err)->Void in
                if let e = error {
                    e(err)
                }
        })
    }

    /// EZSE: converts NSData to JSON dictionary
    private static func dataToJsonDict(data: NSData?) -> AnyObject? {
        if let d = data {
            var error: NSError?
            let json: AnyObject?
            do {
                json = try NSJSONSerialization.JSONObjectWithData(
                    d,
                    options: NSJSONReadingOptions.AllowFragments)
            } catch let error1 as NSError {
                error = error1
                json = nil
            }

            if let _ = error {
                return nil
            } else {
                return json
            }
        } else {
            return nil
        }
    }

    /// EZSE: 
    private static func requestURL(url: String, success: (NSData?) -> Void, error: ((NSError) -> Void)? = nil) {
        NSURLSession.sharedSession().dataTaskWithRequest(
            NSURLRequest(URL: NSURL (string: url)!),
            completionHandler: { data, response, err in
                if let e = err {
                    error?(e)
                } else {
                    success(data)
                }
        }).resume()
    }

}
