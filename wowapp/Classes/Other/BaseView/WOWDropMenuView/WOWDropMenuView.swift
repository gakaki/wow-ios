//
//  WOWDropMenuView.swift
//  Wow
//
//  Created by 小黑 on 16/4/8.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import Foundation


struct WOWDropMenuSetting {
    
    static var columnTitles = ["下拉菜单"]
    
    static var rowTitles =  [
                                ["尖叫君","尖叫君"]
                            ]
    static var columnTitleFont:UIFont = UIFont.init(name:"HelveticaNeue-Medium", size:13)!
    
    static var showBlur = false
    
    static var maskColor = MGRgb(0, g: 0, b: 0, alpha: 0.6)
    
    static var cellHeight:CGFloat = 40
    
    static var maxShowCellNumber:Int = 4
    
    /// 每列的title是否等宽
    static var columnEqualWidth:Bool = false
    
    static var cellTextLabelColor:UIColor = UIColor.blackColor()
    
    static var cellTextLabelSelectColoror:UIColor = UIColor.blackColor()
    
    static var tableViewBackgroundColor:UIColor = UIColor.whiteColor()
    
    static var markImage:UIImage? = UIImage(named:"duihao")
    
    static var showDuration:NSTimeInterval = 0.3
    
    static var cellSeparatorColor:UIColor = MGRgb(224, g: 224, b: 224)
    
    static var cellSelectionColor:UIColor = UIColor.lightGrayColor()
    
    static var cellBackgroundColor:UIColor = UIColor.whiteColor()
    //列数
    private static var columnNumber:Int = 0
}


protocol DropMenuViewDelegate:class{
    func dropMenuClick(column:Int,row:Int)
}



class WOWDropMenuView: UIView {
    private var headerView: UIView!
    private var backView:UIView!
    private var bottomButton:UIButton!
    private var currentColumn:Int = 0
    private var show:Bool = false
    var columItemArr = [WOWDropMenuColumn]()
    //存放的是每一列正在选择的title  row = value
    var columnShowingDict = [Int:String]()
    
    weak var delegate:DropMenuViewDelegate?
    
    private var expandTableViewHeight = CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight
    
    private lazy var tableView:UITableView = {
        let v = UITableView(frame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0), style:.Plain)
        v.separatorColor = WOWDropMenuSetting.cellSeparatorColor
        v.delegate = self
        v.dataSource = self
        return v
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initData()
        configSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initData(){
        assert(WOWDropMenuSetting.columnTitles.count == WOWDropMenuSetting.rowTitles.count,"其中一列的list数据为空")
        WOWDropMenuSetting.columnNumber = WOWDropMenuSetting.columnTitles.count
        for (index,title) in WOWDropMenuSetting.columnTitles.enumerate() {
            columnShowingDict[index] = title
        }
    }
    
    private func configSubView(){
        configHeaderView()
        //添加下方阴影线
        let line = UIImageView()
        let image = UIImage(named: "shadowLine")
        line.image = image?.stretchableImageWithLeftCapWidth(Int((image?.size.width)!)/2, topCapHeight:Int((image?.size.height)!) / 2)
        addSubview(line)
        line.snp_makeConstraints { [weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf).offset(0)
                make.height.equalTo(0.5)
            }
        }
        
        
        bottomButton = UIButton(type:.System)
        bottomButton.frame = CGRectMake(0, CGRectGetHeight(frame)-2, CGRectGetWidth(frame),21)
        bottomButton.setBackgroundImage(UIImage(named: "icon_chose_bottom"), forState: .Normal)
        bottomButton.addTarget(self, action:#selector(bottomButtonClick(_:)), forControlEvents:.TouchUpInside)
        bottomButton.hidden = true
        
        backView = UIView(frame:CGRectMake(0,CGRectGetHeight(frame),CGRectGetWidth(frame),UIScreen.mainScreen().bounds.size.height))
        backView.hidden = true
        backView.backgroundColor = WOWDropMenuSetting.maskColor
        backView.alpha = 0
        
        //添加背景毛玻璃效果
        if WOWDropMenuSetting.showBlur {
            let blurEffect = UIBlurEffect(style: .Light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height)
            backView.addSubview(blurView)
        }
        //添加点击手势
        let tap = UITapGestureRecognizer(target: self, action:#selector(backTap))
        backView.addGestureRecognizer(tap)
    }
    
    private func configHeaderView(){
        headerView = UIView(frame: CGRectMake(0,0,frame.size.width,frame.size.height))
        for (index,title) in WOWDropMenuSetting.columnTitles.enumerate() {
            let columnItem = NSBundle.loadResourceName(String(WOWDropMenuColumn)) as! WOWDropMenuColumn
            columnItem.titleButton.setTitle(title, forState: .Normal)
            columnItem.titleButton.addTarget(self, action:#selector(columnTitleClick(_:)), forControlEvents:.TouchUpInside)
            columnItem.titleButton.tag = index
            headerView.addSubview(columnItem)
            if WOWDropMenuSetting.columnEqualWidth {
                let columnWidth = (UIScreen.mainScreen().bounds.size.width - 30) / CGFloat(WOWDropMenuSetting.columnTitles.count)
                if index == 0 {
                    columnItem.snp_makeConstraints(closure: { (make) in
                        make.left.top.bottom.equalTo(headerView).offset(0)
                        make.width.equalTo(columnWidth)
                    })
                }else{
                    columnItem.snp_makeConstraints(closure: { (make) in
                        make.left.equalTo(columItemArr[index - 1].snp_right).offset(5)
                        make.width.equalTo(columnWidth)
                        make.centerY.equalTo(headerView)
                    })
                }
            }else{
                if index == 0 {
                    columnItem.snp_makeConstraints(closure: { (make) in
                        make.left.top.bottom.equalTo(headerView).offset(0)
                    })
                }else{
                    columnItem.snp_makeConstraints(closure: { (make) in
                        make.left.equalTo(columItemArr[index - 1].snp_right).offset(5)
                        make.centerY.equalTo(headerView)
                    })
                }
            }
            
            columItemArr.append(columnItem)
        }
        self.addSubview(headerView)
    }
    
    private func refreshData(){
        
    }
    
    func  backTap(){
        hide()
    }
    
    func bottomButtonClick(sender:UIButton) {
        hide()
    }
    
    func columnTitleClick(btn:UIButton){
        DLog(btn.tag)
        show = !show
        if currentColumn != btn.tag {
            show = true
            UIView.animateWithDuration(WOWDropMenuSetting.showDuration, animations: {[weak self] () -> () in
                if let strongSelf = self {
                   strongSelf.columItemArr[strongSelf.currentColumn].arrowImageView.transform = CGAffineTransformIdentity
                }
            })
        }else{
            
        }
        currentColumn = btn.tag
        if show {
            rotateArrow()
            tableView.hidden = false
            backView.hidden  = false
            bottomButton.hidden = false
            tableView.frame = CGRectMake(0, self.y + self.h,self.w, 0)
            bottomButton.frame = CGRectMake(0,self.y + self.h,self.w,21)
            backView.frame = CGRectMake(0, self.y + self.h, self.w, MGScreenHeight)
            self.superview?.addSubview(tableView)
            self.superview?.addSubview(bottomButton)
            self.superview?.addSubview(backView)
            self.superview?.insertSubview(backView, belowSubview: tableView)
            UIView.animateWithDuration(WOWDropMenuSetting.showDuration, animations: {
                self.tableView.h = CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight
                self.bottomButton.y = CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight + CGRectGetHeight(self.frame) - CGFloat(2)
                self.backView.alpha = 0.8
            })
        }else{
            hide()
        }
        tableView.reloadData()
    }
    
    private func rotateArrow() {
        UIView.animateWithDuration(WOWDropMenuSetting.showDuration, animations: {[weak self] () -> () in
            if let strongSelf = self {
               strongSelf.columItemArr[strongSelf.currentColumn].arrowImageView.transform = CGAffineTransformRotate(strongSelf.columItemArr[strongSelf.currentColumn].arrowImageView.transform, 180 * CGFloat(M_PI/180))
            }
        })
    }
    
    func hide(){
        show = false
        UIView.animateWithDuration(WOWDropMenuSetting.showDuration, animations: {
            self.tableView.h = 0
            self.bottomButton.y -= CGFloat(WOWDropMenuSetting.maxShowCellNumber) * WOWDropMenuSetting.cellHeight
            self.columItemArr[self.currentColumn].arrowImageView.transform = CGAffineTransformIdentity
            self.backView.alpha = 0
            }, completion: { (ret) in
                self.tableView.hidden = true
                self.bottomButton.hidden = true
                self.backView.hidden = true
                self.tableView.removeFromSuperview()
                self.bottomButton.removeFromSuperview()
                self.backView.removeFromSuperview()
        })
    }
    
}


extension WOWDropMenuView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WOWDropMenuSetting.rowTitles[currentColumn].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WOWDropMenuSetting.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "MenuCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier:cellID)
            cell?.textLabel?.font = Fontlevel001
            cell?.textLabel?.textColor = UIColor.blackColor()
            let image = UIImage(named: "duihao")
            let markImageView = UIImageView(frame:CGRectMake(CGRectGetWidth(frame) - (image?.size.width)! - 15,0,(image?.size.width)!, (image?.size.height)!))
            markImageView.centerY = (cell?.contentView.centerY)!
            markImageView.tag = 10001
            markImageView.image = image
            cell?.contentView.addSubview(markImageView)
        }
        let titles = WOWDropMenuSetting.rowTitles[currentColumn]
        cell?.textLabel?.text = titles[indexPath.row]
        cell?.textLabel?.textColor = columnShowingDict[currentColumn] == titles[indexPath.row] ? WOWDropMenuSetting.cellTextLabelSelectColoror : WOWDropMenuSetting.cellTextLabelColor
        if columnShowingDict[currentColumn] == titles[indexPath.row] {
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition:.None, animated: true)
        }
        cell?.contentView.viewWithTag(10001)?.hidden = !(columnShowingDict[currentColumn] == titles[indexPath.row])
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title = WOWDropMenuSetting.rowTitles[currentColumn][indexPath.row]
        columItemArr[currentColumn].titleButton.setTitle(title, forState: .Normal)
        columnShowingDict[currentColumn] = title
        hide()
        if let del = self.delegate {
            del.dropMenuClick(currentColumn, row: indexPath.row)
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = WOWDropMenuSetting.cellSelectionColor
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = WOWDropMenuSetting.cellBackgroundColor
    }
    
    
}