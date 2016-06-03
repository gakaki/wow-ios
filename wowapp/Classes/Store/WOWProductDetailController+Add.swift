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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1: //参数
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
        default:
            break
        }
        return returnCell
    }
}