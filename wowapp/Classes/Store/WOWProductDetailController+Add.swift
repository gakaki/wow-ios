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
        tableView.tableHeaderView = cycleView   //banner轮播
        //显示价格的cell
        tableView.registerNib(UINib.nibName(String(WOWProductDetailPriceCell)), forCellReuseIdentifier:String(WOWProductDetailPriceCell))
        //品牌故事
        tableView.registerNib(UINib.nibName(String(WOWProductDetailDescCell)), forCellReuseIdentifier:String(WOWProductDetailDescCell))
        //产品描述
        tableView.registerNib(UINib.nibName(String(WOWProductDetailCell)), forCellReuseIdentifier:String(WOWProductDetailCell))
        //产品参数
        tableView.registerNib(UINib.nibName(String(WOWProductParameter)), forCellReuseIdentifier:String(WOWProductParameter))
        //温馨提示
        tableView.registerNib(UINib.nibName(String(WOWProductDetailTipsWebViewCell)), forCellReuseIdentifier:String(WOWProductDetailTipsWebViewCell))
        //客服电话
        tableView.registerNib(UINib.nibName(String(WOWTelCell)), forCellReuseIdentifier:String(WOWTelCell))
        //相关商品
        tableView.registerNib(UINib.nibName(String(WOWProductDetailAboutCell)), forCellReuseIdentifier:String(WOWProductDetailAboutCell))
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 1
        case 3: //产品参数可展开
            if isOpenParam {
                return 1
            }else {
                return 0   
            }
        case 4: //温馨提示也可展开
            if isOpenTips {
                return 1
            }else {
                return 0
            }
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch (indexPath.section,indexPath.row) {
        case (0,_): //标题价钱
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailPriceCell), forIndexPath: indexPath) as! WOWProductDetailPriceCell
            cell.nameLabel.text = productModel?.productName ?? ""
            if let price = productModel?.sellPrice {
                let result = WOWCalPrice.calTotalPrice([price],counts:[1])
                cell.actualPriceLabel.text = result
                if let originalPrice = productModel?.original_price {
                    if originalPrice > price{
                        //显示下划线
                        let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                        
                        cell.originalPriceLabel.setStrokeWithText(result)
                        
                    }
                }
            }
            returnCell = cell
        case (1,_): //品牌设计师
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailDescCell), forIndexPath: indexPath) as! WOWProductDetailDescCell
            cell.showData(self.productModel)
            returnCell = cell
        case (2,_): //产品描述
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailCell), forIndexPath: indexPath) as! WOWProductDetailCell
            
            returnCell = cell
        case (3,_): //参数

            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWProductParameter), forIndexPath: indexPath) as! WOWProductParameter
            
            if let parameter = productModel?.productParameter {
                  cell.showData(parameter)
            }

            returnCell = cell
        case (4,_)://温馨提示
            
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailTipsWebViewCell", forIndexPath: indexPath) as! WOWProductDetailTipsWebViewCell
            returnCell = cell
        case (5,_): //客服电话
            let cell =  tableView.dequeueReusableCellWithIdentifier(String(WOWTelCell), forIndexPath: indexPath) as! WOWTelCell
            
            returnCell = cell
        case (6,_)://相关商品
            let cell = tableView.dequeueReusableCellWithIdentifier("WOWProductDetailAboutCell", forIndexPath: indexPath) as! WOWProductDetailAboutCell
            cell.delegate = self
            cell.showData()
            returnCell = cell
        default:
            break
        }
        return returnCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            //动态获取产品描述的label高度
            return 64 + productDescView.productDescLabel.getEstimatedHeight()
        case 3,4:
            //产品参数与温馨提示cell头
            return 60
        case 6:
            return 15
        default:
            return 0.01
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 3:
            return 0.01
        default:
            return 15
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 6:
            return "相关商品"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:     //产品描述
            return productDescView
        case 3:     
            paramView.label.text = "产品参数"
            paramView.openImg.addTapGesture(action: { [weak self](tap) in
                if let strongSelf = self  {
                    strongSelf.isOpenParam = !strongSelf.isOpenParam
                    strongSelf.paramView.isOpen(strongSelf.isOpenParam)
                    let sections = NSIndexSet(index: section)
                    tableView.reloadSections(sections, withRowAnimation: .Automatic)
                }
            })
            return paramView
        case 4:
            tipsView.label.text = "温馨提示"
            tipsView.openImg.addTapGesture(action: { [weak self](tap) in
                if let strongSelf = self  {
                    strongSelf.isOpenTips = !strongSelf.isOpenTips
                    strongSelf.tipsView.isOpen(strongSelf.isOpenTips)
                    let sections = NSIndexSet(index: section)
                    tableView.reloadSections(sections, withRowAnimation: .Automatic)
                }
                })
            return tipsView
        default:
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 5:
            WOWTool.callPhone()
        default:
            break
        }
    }
    
}

extension WOWProductDetailController: WOWProductDetailAboutCellDelegate {
    func requestAboutProduct(productDetailAboutCell:WOWProductDetailAboutCell, pageIndex: Int, isRreshing: Bool, pageSize: Int) {
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_ProductBrand(brandId:productModel?.brandId ?? 0, pageSize: pageSize, currentPage: pageIndex), successClosure: {(result) in
            
                productDetailAboutCell.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    
                    if productDetailAboutCell.pageIndex == 1{
                        productDetailAboutCell.dataArr = []
                    }
                    productDetailAboutCell.dataArr?.appendContentsOf(array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < productDetailAboutCell.pageSize {
                        productDetailAboutCell.collectionView.mj_footer = nil
                        
                    }else {
                        productDetailAboutCell.collectionView.mj_footer = productDetailAboutCell.mj_footer
                    }
                    
                }else {
                    if productDetailAboutCell.pageIndex == 1{
                        productDetailAboutCell.dataArr = []
                    }
                    
                    productDetailAboutCell.collectionView.mj_footer = nil
                    
                }
                productDetailAboutCell.collectionView.reloadData()
                
            
            
        }) {(errorMsg) in
            
                productDetailAboutCell.collectionView.mj_footer = nil
                productDetailAboutCell.endRefresh()
            
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


