// Copyright © 2015 Venture Media Labs. All rights reserved.
//
// This file is part of StyleKit. The full StyleKit copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import UIKit

var UIViewStyleKey: UInt8 = 0

public extension UIView {

    @IBInspectable var styleClass: String? {
        get {
            return objc_getAssociatedObject(self, &UIViewStyleKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIViewStyleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    internal func StyleKit_awakeFromNib() {
        if respondsToSelector(Selector("StyleKit_awakeFromNib")) {
            StyleKit_awakeFromNib()
            applyStyles()
        }
    }

    internal func applyStyles() {
        guard let styleClass = styleClass else { return }
        StyleKit.applyStyle(styleClass, toView:self)
    }
    
}
