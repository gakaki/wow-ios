//
//  WOWCheckSelectView.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

struct WOWCheckMenuSetting {
    static var fill:Bool = false
    static var margin:CGFloat = 15
    static var itemMargin:CGFloat = 30
    static var selectedIndex:Int = 0
    static var normalTitleColor = GrayColorlevel3
    static var selectTitleColor = UIColor.black
    static var titleFont:UIFont = UIFont.systemScaleFontSize(12)
    
    static func defaultSetUp(){
        fill             = false
        margin           = 15
        itemMargin       = 30
        selectedIndex    = 0
        normalTitleColor = GrayColorlevel3
        selectTitleColor = UIColor.black
        titleFont        = UIFont.systemScaleFontSize(14)
    }
}



protocol TopMenuProtocol:class{
    func topMenuItemClick(_ index:Int)
}

class WOWTopMenuTitleView: UIView {
    weak var delegate:TopMenuProtocol?
    
    var selectedIndex = WOWCheckMenuSetting.selectedIndex{
        didSet{
            changeIndex()
        }
    }
    
    var itemTitles :[String]!
    
    var itemWidths:[CGFloat]!
    
    fileprivate var titleTotalWidth:CGFloat = 0
    
    fileprivate var itemArr = [UIButton]()
    
    fileprivate lazy var bottomLine:UIView = {
        let v = UIView(frame: CGRect(x: 0,y: 0,width: 20,height: 1))
        v.backgroundColor = ThemeBlackColor
//        v.backgroundColor =  UIColor.init(hexString: "000000")
        return v
    }()
    
    convenience init(frame: CGRect,titles:[String]) {
        self.init(frame:frame)
        itemTitles = titles
        configSubViews()
    }
    
    fileprivate func configSubViews(){
        backgroundColor = UIColor.white
        itemWidths = itemTitles.map({
            $0.size(WOWCheckMenuSetting.titleFont).width + 8
        })
        titleTotalWidth = itemWidths.reduce(0, {$0 + $1})
        configItems()
    }
    
    fileprivate func configItems(){
        if  WOWCheckMenuSetting.fill{ //铺满
            WOWCheckMenuSetting.itemMargin = (self.w - titleTotalWidth - WOWCheckMenuSetting.margin * 2) / CGFloat((itemTitles.count - 1))
        }else{ //不铺满
             let restWidth = self.w - titleTotalWidth - WOWCheckMenuSetting.itemMargin * CGFloat((itemTitles.count - 1))
             WOWCheckMenuSetting.margin = restWidth / 2
        }
        
        for (index,item) in itemTitles.enumerated(){
            let btn = createItem(item)
            if index == 0 {
                btn.frame = CGRect(x: WOWCheckMenuSetting.margin, y: 5,width: itemWidths[index],height: self.h-5)
            }else{
                btn.frame = CGRect(x: itemArr[index - 1].right + WOWCheckMenuSetting.itemMargin,y: 5,width: itemWidths[index],height: self.h - 5)
            }
            btn.tag = 1000 + index
            btn.addTarget(self, action:#selector(itemClick(_:)), for:.touchUpInside)
            self.addSubview(btn)
            itemArr.append(btn)
        }
        itemArr[selectedIndex].isSelected = true
        //下划线
        bottomLine.frame = self.itemArr[WOWCheckMenuSetting.selectedIndex].frame
        
        bottomLine.y = self.h - 3
        bottomLine.h = 3
//        bottomLine.w += 20
        bottomLine.w = 56
//        print("\(bottomLine.frame.width)")
        bottomLine.centerX = self.itemArr[WOWCheckMenuSetting.selectedIndex].centerX
        self.addSubview(bottomLine)
    }
    
    
    
    func itemClick(_ btn:UIButton){
        let index = btn.tag - 1000
        guard selectedIndex != index else{
            return
        }
        let centerX = itemArr[index].centerX
        UIView.animate(withDuration: 0.4) { 
            self.bottomLine.centerX = centerX
        }
        itemArr[selectedIndex].isSelected = false
        selectedIndex = index
        itemArr[selectedIndex].isSelected = true
        if  let del = self.delegate{
            del.topMenuItemClick(selectedIndex)
        }
    }
    
    fileprivate func changeIndex(){
        itemArr[selectedIndex].isSelected = true
        let centerX = itemArr[selectedIndex].centerX
        UIView.animate(withDuration: 0.4) {
            self.bottomLine.centerX = centerX
        }
    }
    
    fileprivate func createItem(_ title:String) ->UIButton{
        let button = UIButton(type:.system)
        button.titleLabel?.font = WOWCheckMenuSetting.titleFont
        button.setTitleColor(WOWCheckMenuSetting.normalTitleColor, for: .normal)
        button.setTitleColor(WOWCheckMenuSetting.selectTitleColor, for: .selected)
        button.tintColor = UIColor.white
        button.setTitle(title, for: UIControlState())
        return button
    }
    
//MARK:Public Func

    
}
