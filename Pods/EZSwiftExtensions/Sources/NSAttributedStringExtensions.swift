//
//  NSAttributedStringExtensions.swift
//  EZSwiftExtensions
//
//  Created by Lucas Farah on 18/02/16.
//  Copyright (c) 2016 Lucas Farah. All rights reserved.
//
import UIKit

extension NSAttributedString {

    /// EZSE: Adds bold attribute to NSAttributedString and returns it
    func bold() -> NSAttributedString {
        let copy = self.mutableCopy()
        let range = (self.string as NSString).rangeOfString(self.string)
        copy.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(UIFont.systemFontSize())], range: range)
        return copy as! NSAttributedString
    }
  
    /// EZSE: Adds underline attribute to NSAttributedString and returns it
    func underline() -> NSAttributedString {
        let copy = self.mutableCopy()
        let range = (self.string as NSString).rangeOfString(self.string)
        copy.addAttributes([NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue], range: range)
        return copy as! NSAttributedString
    }
  
    /// EZSE: Adds italic attribute to NSAttributedString and returns it
    func italic() -> NSAttributedString {
        let copy = self.mutableCopy()
        let range = (self.string as NSString).rangeOfString(self.string)
        copy.addAttributes([NSFontAttributeName: UIFont.italicSystemFontOfSize(UIFont.systemFontSize())], range: range)
        return copy as! NSAttributedString
    }
  
    /// EZSE: Adds color attribute to NSAttributedString and returns it
    func color(color: UIColor) -> NSAttributedString {
        let copy = self.mutableCopy()
        let range = (self.string as NSString).rangeOfString(self.string)
        copy.addAttributes([NSForegroundColorAttributeName: color], range: range)
        return copy as! NSAttributedString
    }
}

/// EZSE: Appends one NSAttributedString to another NSAttributedString and returns it
public func += (inout left: NSAttributedString, right: NSAttributedString) {
    let ns = NSMutableAttributedString(attributedString: left)
    ns.appendAttributedString(right)
    left = ns
}

