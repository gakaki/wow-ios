// Copyright © 2015 Venture Media Labs. All rights reserved.
//
// This file is part of StyleKit. The full StyleKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

public protocol StyleHandler {

    var name: String { get }

    func apply(view: UIView)

}

public class StyleKit: NSObject {

    private static let sharedInstance = StyleKit()

    private var handlers = [StyleHandler]()

    public class func configure(handlers: [StyleHandler]) {
        UIView.swizzleMethodSelector("awakeFromNib", withSelector: "StyleKit_awakeFromNib", forClass: UIView.classForCoder())
        for handler in handlers {
            sharedInstance.handlers.append(handler)
        }
    }

    public class func applyStyle(styleClassNames: String, toView: UIView) {
        let names = styleClassNames.componentsSeparatedByString(";")
        for name in names {
            var handlerFound = false
            for handler in sharedInstance.handlers {
                if handler.name == name {
                    handler.apply(toView)
                    handlerFound = true
                }
            }
            if handlerFound == false {
                print("StyleHandler '\(name)' not found")
            #if DEBUG
                fatalError()
            #endif
            }
        }
    }

}
