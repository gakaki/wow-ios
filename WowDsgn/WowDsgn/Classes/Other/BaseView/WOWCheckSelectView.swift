//
//  WOWCheckSelectView.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

struct CheckMenuSetting {
    static var fill:Bool = false
    static var margin:CGFloat = 15
    static var itemMargin:CGFloat = 30
    static var selectedIndex:Int = 0
    static var normalTitleColor = UIColor.blackColor()
    static var selectTitleColor = UIColor(red: 74/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1)
    static var titleFont:UIFont = UIFont.systemScaleFontSize(12)
}



protocol TopMenuProtocol:class{
    func topMenuItemClick(index:Int)
}

class TopMenuTitleView: UIView {
    weak var delegate:TopMenuProtocol?
    
    var selectedIndex = CheckMenuSetting.selectedIndex{
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
        v.backgroundColor = ThemeColor
        return v
    }()
    
    convenience init(frame: CGRect,titles:[String]) {
        self.init(frame:frame)
        itemTitles = titles
        configSubViews()
    }
    
    private func configSubViews(){
        itemWidths = itemTitles.map({
            $0.size(CheckMenuSetting.titleFont).width + 8
        })
        titleTotalWidth = itemWidths.reduce(0, combine:{$0 + $1})
        
        configItems()
    }
    
    private func configItems(){
        if  CheckMenuSetting.fill{ //铺满
            CheckMenuSetting.itemMargin = (self.width - titleTotalWidth - CheckMenuSetting.margin * 2) / CGFloat((itemTitles.count - 1))
        }else{ //不铺满
             let restWidth = self.width - titleTotalWidth - CheckMenuSetting.itemMargin * CGFloat((itemTitles.count - 1))
             CheckMenuSetting.margin = restWidth / 2
        }
        
        for (index,item) in itemTitles.enumerate(){
            let btn = createItem(item)
            if index == selectedIndex {
                btn.frame = CGRectMake(CheckMenuSetting.margin, 5,itemWidths[index],self.height-5)
            }else{
                btn.frame = CGRectMake(itemArr[index - 1].right + CheckMenuSetting.itemMargin,5,itemWidths[index],self.height-5)
            }
            btn.tag = 1000 + index
            btn.addTarget(self, action:#selector(itemClick(_:)), forControlEvents:.TouchUpInside)
            self.addSubview(btn)
            itemArr.append(btn)
        }
        
        //下划线
        bottomLine.frame = self.itemArr[CheckMenuSetting.selectedIndex].frame
        bottomLine.y = self.height - 3
        bottomLine.height = 2
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
        button.titleLabel?.font = CheckMenuSetting.titleFont
        button.setTitleColor(CheckMenuSetting.normalTitleColor, forState: .Normal)
        button.setTitleColor(CheckMenuSetting.selectTitleColor, forState: .Selected)
        button.tintColor = UIColor.whiteColor()
        button.setTitle(title, forState: .Normal)
        return button
    }
    
//MARK:Public Func

    
}
