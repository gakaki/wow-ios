//
//  AppDelegate.swift
//  wow3rd
//
//  Created by gakaki on 10/26/2016.
//  Copyright (c) 2016 gakaki. All rights reserved.
//

import UIKit
import wow3rd

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let wv                              = UIViewController()
        self.window                         = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController     = wv
        self.window?.makeKeyAndVisible()
        return true
    }
 

}

