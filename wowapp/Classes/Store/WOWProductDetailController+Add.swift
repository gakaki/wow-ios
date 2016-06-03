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
        default:
            break
        }
        return returnCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 30
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 3:
            let v = DetailSectionView(leftTitle: "评论")
            return v
        default:
            return nil
        }
    }
    
    
}

class DetailSectionView:UIView{
    var leftLabel:UILabel!
    var line:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


