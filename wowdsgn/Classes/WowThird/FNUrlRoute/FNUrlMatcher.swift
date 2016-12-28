//
//  FNUrlMatcher.swift
//  FNUrlRoute
//
//  Created by Fnoz on 2016/10/31.
//  Copyright © 2016年 Fnoz. All rights reserved.
//

import UIKit

public class FNUrlMatcher {
    public static let shared = FNUrlMatcher()
    public var urlDictionary: Dictionary<String, AnyClass> = [:]

    public class func fetchModuleClass(key: String) -> AnyClass? {
        return FNUrlMatcher.shared.urlDictionary[key]
    }
}
