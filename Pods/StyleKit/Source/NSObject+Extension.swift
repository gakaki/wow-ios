// Copyright © 2015 Venture Media Labs. All rights reserved.
//
// This file is part of StyleKit. The full StyleKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

extension NSObject {

    class func swizzleMethodSelector(origSelector: String, withSelector: String, forClass: AnyClass) {
        let originalMethod = class_getInstanceMethod(forClass, Selector(origSelector))
        let swizzledMethod = class_getInstanceMethod(forClass, Selector(withSelector))
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
}
