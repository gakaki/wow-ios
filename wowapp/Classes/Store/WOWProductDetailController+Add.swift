//
//  WOWProductDetailController+Add.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import Foundation
import UIKit

extension WOWProductDetailController:UITableViewDelegate,UITableViewDataSource{
     func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.mj_header = self.mj_header
        tableView.tableHeaderView = cycleView
        tableView.registerNib(UINib.nibName(String(WOWProductDetailPriceCell)), forCellReuseIdentifier:String(WOWProductDetailPriceCell))
        tableView.registerNib(UINib.nibName(String(WOWProductDetailDescCell)), forCellReuseIdentifier:String(WOWProductDetailDescCell))
        tableView.registerNib(UINib.nibName(String(WOWProductDetailPicTextCell)), forCellReuseIdentifier:String(WOWProductDetailPicTextCell))
        tableView.registerNib(UINib.nibName(String(WOWProductDetailAttriCell)), forCellReuseIdentifier:String(WOWProductDetailAttriCell))
        tableView.registerNib(UINib.nibName(String(WOWProductDetailTipsCell)), forCellReuseIdentifier:String(WOWProductDetailTipsCell))
        tableView.registerNib(UINib.nibName(String(WOWCommentCell)), forCellReuseIdentifier:String(WOWCommentCell))
        tableView.registerNib(UINib.nibName(String(WOWProductDetailAboutCell)), forCellReuseIdentifier: "WOWProductDetailAboutCell")
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1: //参数
            return 1
        case 2: //温馨提示
            return 1
        case 3: //评论
            return 3
        case 4: //相关商品
            return 1
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch (indexPath.section,indexPath.row) {
        case (0,0): //标题价钱
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailPriceCell), forIndexPath: indexPath) as! WOWProductDetailPriceCell
            cell.nameLabel.text = productModel?.productName
            cell.actualPriceLabel.text = productModel?.price?.priceFormat()
            returnCell = cell
        case (0,1): //品牌设计师
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailDescCell), forIndexPath: indexPath) as! WOWProductDetailDescCell
            cell.showData(self.productModel)
            returnCell = cell
        case (0,2): //图文详情
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailPicTextCell), forIndexPath: indexPath) as! WOWProductDetailPicTextCell
            if let pics = productModel?.pics_compose{
                let model = pics[0]
                cell.showData(model)
            }
            returnCell = cell
        case (1,0): //参数
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailAttriCell", forIndexPath: indexPath) as! WOWProductDetailAttriCell
             cell.dataArr = productModel?.attributes
            returnCell = cell
        case (2,0)://温馨提示
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailTipsCell", forIndexPath: indexPath) as! WOWProductDetailTipsCell
            returnCell = cell
        case (3,_)://评论
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWCommentCell", forIndexPath: indexPath) as! WOWCommentCell
            returnCell = cell
        case (4,_)://相关商品
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailAboutCell", forIndexPath: indexPath) as! WOWProductDetailAboutCell
            //FIXME:测试
            cell.dataArr = [productModel!,productModel!,productModel!,productModel!,productModel!]
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 30
        case 4://相关商品
            return 50
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 60
        case 4:
            return 20
        default:
            return 0.01
        }
    }
    
//    func tableView(tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//            headerView.textLabel?.textColor = GrayColorlevel3
//            headerView.textLabel?.font = Fontlevel004
//        }
//    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 4:
//            return "相关商品"
//        default:
//            return nil
//        }
//    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 3://评论
            let v = DetailSectionHeaderView(leftTitle:"评论")
            return v
        case 4: //相关商品
            let v = DetailSectionHeaderView(leftTitle:"相关商品", backColor:DefaultBackColor, leftTtileColor:GrayColorlevel3)
            v.line.hidden = true
            return v
        default:
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 3:
            let v = DetailSectionFooterView(frame:CGRectMake(0, 0, MGScreenWidth, 60))
            v.addTapGesture(action: {[weak self](tap) in
                if let _ = self{
                    DLog("更多评论咯")
                }
            })
            return v
        default:
            return nil
        }
    }
}


class DetailSectionFooterView:UIView{
    var containerView = UIView()
    var leftLabel = UILabel()
    var rightImageView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        configSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSubview(){
        addSubview(containerView)
        containerView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.center.equalTo(strongSelf.snp_center)
            }
        }
        
        containerView.addSubview(leftLabel)
        leftLabel.text = "查看详情"
        leftLabel.font = Fontlevel004
        leftLabel.textColor = GrayColorlevel3
        leftLabel.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.bottom.equalTo(strongSelf.containerView).offset(0)
            }
        }
        rightImageView.image = UIImage(named: "detailmore")
        containerView.addSubview(rightImageView)
        rightImageView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.right.equalTo(strongSelf.containerView.snp_right).offset(0)
                make.left.equalTo(strongSelf.leftLabel.snp_right).offset(5)
                make.centerY.equalTo(strongSelf.leftLabel.snp_centerY)
            }
        }
        
    }
    
}

class DetailSectionHeaderView:UIView{
    var leftLabel:UILabel!
    var line:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
    }
    
    private func configSubviews(){
        leftLabel = UILabel()
        addSubview(leftLabel)
        leftLabel.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.equalTo(strongSelf.snp_left).offset(15)
                make.centerY.equalTo(strongSelf.snp_centerY)
            }
        }
        line = UIView()
        line.backgroundColor = SeprateColor
        addSubview(line)
        line.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.equalTo(strongSelf.leftLabel.snp_right).offset(10)
                make.right.equalTo(strongSelf).offset(0)
                make.centerY.equalTo(strongSelf.leftLabel.snp_centerY)
                make.height.equalTo(0.5)
            }
        }
        
    }
    
    convenience init(leftTitle:String,backColor:UIColor = UIColor.whiteColor(),leftTtileColor:UIColor = UIColor.blackColor()){
        self.init(frame:CGRectMake(0,0,MGScreenWidth,30))
        self.backgroundColor = backColor
        self.leftLabel.textColor = leftTtileColor
        self.leftLabel.text = leftTitle
        self.leftLabel.font = Fontlevel002
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

