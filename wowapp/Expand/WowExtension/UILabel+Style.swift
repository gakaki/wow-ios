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
        if let t = self.text {
            let attrString = NSMutableAttributedString(string: t)
            attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            self.attributedText = attrString

        }
    }
    
    class func initLable(title:String , titleColor:UIColor ,textAlignment:NSTextAlignment ,font:CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.textAlignment = textAlignment
        label.font = UIFont.systemFontOfSize(font)
        return label
    }

}