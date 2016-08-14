//
//  UILabel+Style.swift
//  wowapp
//
//  Created by g on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//


extension UILabel {
    func setLineHeightAndLineBreak(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}