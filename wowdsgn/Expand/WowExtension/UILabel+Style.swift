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
        paragraphStyle.lineBreakMode = .byTruncatingTail
        if let t = self.text {
            let attrString = NSMutableAttributedString(string: t)
            attrString.addAttribute(NSFontAttributeName, value: self.font, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            self.attributedText = attrString

        }
    }
    // 指定的字体改变颜色字体
    func strokeWithText( _ str1:String,str2:String,str2Font:CGFloat,str2Color:UIColor){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.characters.count
        let str1Leng = str2.characters.count
        
        let str1Range = NSMakeRange(strLeng, str1Leng)
        // 颜色
        mustr1 .addAttribute(NSForegroundColorAttributeName, value: str2Color, range: str1Range)
        // 线条
//        mustr1 .addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: str1Range)
        // 字体
        mustr1 .addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: str2Font), range: str1Range)
        
        let strPlace = NSAttributedString.init(string: "  ")
        mustr1.insert(strPlace, at: strLeng)
        
        self.attributedText = mustr1
        
    }
    // 指定的字体加颜色
    func colorWithText( _ str1:String,str2:String,str1Color:UIColor){
        
        let mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.characters.count
        
        let str1Range = NSMakeRange(0, strLeng)
        // 颜色
        mustr1.addAttribute(NSForegroundColorAttributeName, value: str1Color, range: str1Range)
        


        self.attributedText = mustr1
        
    }
    
    // 指定的字体加颜色
    func colorWithTextWithLine( _ str1:String,str2:String,str1Color:UIColor, lineHeight: CGFloat){
        
        let mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.characters.count
        
        let str1Range = NSMakeRange(0, strLeng)
        // 颜色
        mustr1.addAttribute(NSForegroundColorAttributeName, value: str1Color, range: str1Range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        mustr1.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, mustr1.length))
        
        self.attributedText = mustr1
        
    }
    // 指定的范围字体加颜色
    func colorRangeWithText( _ str1:String,str2:String,str3:String = "",changeColor:UIColor){
        
        let  mustr1 = NSMutableAttributedString.init(string: str1 + str2 + str3)
        let strLeng = str1.characters.count
        let str1Leng = str2.characters.count
        
        let range = NSMakeRange(strLeng, str1Leng)
        
        // 颜色
        mustr1.addAttribute(NSForegroundColorAttributeName, value: changeColor, range: range)
        
        
        
        self.attributedText = mustr1
        
    }
    // 改变指定字体
    func fontWithText( _ str1:String,str2:String, font: UIFont){
        
        let mustr1 = NSMutableAttributedString.init(string: str1 + str2)
        
        let strLeng = str1.characters.count
        
        let str1Range = NSMakeRange(0, strLeng)
        // 颜色
        mustr1.addAttribute(NSFontAttributeName, value: font, range: str1Range)
       
        
        self.attributedText = mustr1
        
    }
    // 初始化
    class func initLable(_ title:String , titleColor:UIColor ,textAlignment:NSTextAlignment ,font:CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = titleColor
        label.textAlignment = textAlignment
        label.font = UIFont.systemFont(ofSize: font)
        return label
    }
    func AddBorderRadius()  {
        self.borderColor(0.5, borderColor: UIColor.init(hexString: "cccccc")!)
        self.borderRadius(2)
    }
}
