//
//  UILabel+Style.swift
//  wowapp
//
//  Created by g on 16/8/8.
//  Copyright © 2016年 小黑. All rights reserved.
//


extension UILabel {
    func setLineHeightAndLineBreak(_ lineHeight: CGFloat) {
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
    // 指定的字体加横线
    func strokeWithText( _ str1:String,str2:String,str2Font:CGFloat,str2Color:UIColor){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.characters.count
        let str1Leng = str2.characters.count
        
        let str1Range = NSMakeRange(strLeng, str1Leng)
        // 颜色
        mustr1 .addAttribute(NSForegroundColorAttributeName, value: str2Color, range: str1Range)
        // 线条
        mustr1 .addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: str1Range)
        // 字体
        mustr1 .addAttribute(NSFontAttributeName, value:UIFont.systemFontOfSize(str2Font), range: str1Range)
        
        let strPlace = NSAttributedString.init(string: "  ")
        mustr1 .insertAttributedString(strPlace, atIndex: strLeng)
        
        self.attributedText = mustr1
        
    }

    // 初始化
    class func initLable(_ title:String , titleColor:UIColor ,textAlignment:NSTextAlignment ,font:CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.textAlignment = textAlignment
        label.font = UIFont.systemFontOfSize(font)
        return label
    }

}
