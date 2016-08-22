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
    static var selectTitleColor = UIColor.blackColor()
    static var titleFont:UIFont = UIFont.systemScaleFontSize(12)
    
    static func defaultSetUp(){
        fill             = false
        margin           = 15
        itemMargin       = 30
        selectedIndex    = 0
        normalTitleColor = GrayColorlevel3
        selectTitleColor = UIColor.blackColor()
        titleFont        = UIFont.systemScaleFontSize(14)
    }
}



protocol TopMenuProtocol:class{
    func topMenuItemClick(index:Int)
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
    
    private var titleTotalWidth:CGFloat = 0
    
    private var itemArr = [UIButton]()
    
    private lazy var bottomLine:UIView = {
        let v = UIView(frame: CGRectMake(0,0,20,1))
        v.backgroundColor = ThemeBlackColor
//        v.backgroundColor =  UIColor.init(hexString: "000000")
        return v
    }()
    
    convenience init(frame: CGRect,titles:[String]) {
        self.init(frame:frame)
        itemTitles = titles
        configSubViews()
    }
    
    private func configSubViews(){
        backgroundColor = UIColor.whiteColor()
        itemWidths = itemTitles.map({
            $0.size(WOWCheckMenuSetting.titleFont).width + 8
        })
        titleTotalWidth = itemWidths.reduce(0, combine:{$0 + $1})
        configItems()
    }
    
    private func configItems(){
        if  WOWCheckMenuSetting.fill{ //铺满
            WOWCheckMenuSetting.itemMargin = (self.w - titleTotalWidth - WOWCheckMenuSetting.margin * 2) / CGFloat((itemTitles.count - 1))
        }else{ //不铺满
             let restWidth = self.w - titleTotalWidth - WOWCheckMenuSetting.itemMargin * CGFloat((itemTitles.count - 1))
             WOWCheckMenuSetting.margin = restWidth / 2
        }
        
        for (index,item) in itemTitles.enumerate(){
            let btn = createItem(item)
            if index == 0 {
                btn.frame = CGRectMake(WOWCheckMenuSetting.margin, 5,itemWidths[index],self.h-5)
            }else{
                btn.frame = CGRectMake(itemArr[index - 1].right + WOWCheckMenuSetting.itemMargin,5,itemWidths[index],self.h - 5)
            }
            btn.tag = 1000 + index
            btn.addTarget(self, action:#selector(itemClick(_:)), forControlEvents:.TouchUpInside)
            self.addSubview(btn)
            itemArr.append(btn)
        }
        itemArr[selectedIndex].selected = true
        //下划线
        bottomLine.frame = self.itemArr[WOWCheckMenuSetting.selectedIndex].frame
        bottomLine.y = self.h - 3
        bottomLine.h = 3
        bottomLine.w += 20
        bottomLine.centerX = self.itemArr[WOWCheckMenuSetting.selectedIndex].centerX
        self.addSubview(bottomLine)
    }
    
    
    
    func itemClick(btn:UIButton){
        let index = btn.tag - 1000
        guard selectedIndex != index else{
            return
        }
        let centerX = itemArr[index].centerX
        UIView.animateWithDuration(0.4) { 
            self.bottomLine.centerX = centerX
        }
        itemArr[selectedIndex].selected = false
        selectedIndex = index
        itemArr[selectedIndex].selected = true
        if  let del = self.delegate{
            del.topMenuItemClick(selectedIndex)
        }
    }
    
    private func changeIndex(){
        itemArr[selectedIndex].selected = true
        let centerX = itemArr[selectedIndex].centerX
        UIView.animateWithDuration(0.4) {
            self.bottomLine.centerX = centerX
        }
    }
    
    private func createItem(title:String) ->UIButton{
        let button = UIButton(type:.System)
        button.titleLabel?.font = WOWCheckMenuSetting.titleFont
        button.setTitleColor(WOWCheckMenuSetting.normalTitleColor, forState: .Normal)
        button.setTitleColor(WOWCheckMenuSetting.selectTitleColor, forState: .Selected)
        button.tintColor = UIColor.whiteColor()
        button.setTitle(title, forState: .Normal)
        return button
    }
    
//MARK:Public Func

    
}
