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
            return productModel?.secondaryImgs?.count ?? 0
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
                if let originalPrice = productModel?.originalprice {
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
            if let array = productModel?.secondaryImgs {
                let model = array[indexPath.row]
                cell.showData(model)
                cell.productImg.tag = indexPath.row
                cell.productImg.addTapGesture(action: {[weak self] (tap) in
                    if let strongSelf = self {
                        strongSelf.lookBigImg((tap.view?.tag)!)
                    }
                    
                })
            }
            
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
            cell.dataArr = aboutProductArray
            if aboutProductArray.count == 6 {
                if noMoreData {
                    cell.collectionView.xzm_footer = cell.xzm_footer
                }else {
                    cell.collectionView.xzm_footer = nil
                }
            }
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
            return 67 + productDescView.productDescLabel.getEstimatedHeight()
        case 3,4:
            //产品参数与温馨提示cell头
            return 60
        case 6: //如果相关商品有数据显示，如果没有就不显示
            if aboutProductArray.count > 0 {
                return 15
            }else {
                return 0.01
            }
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
        case 6:     //如果相关商品有数据显示，如果没有就不显示
            if aboutProductArray.count > 0 {
                return "相关商品"
            }else {
                return nil
            }
            
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
    func aboutProduct(productDetailAboutCell:WOWProductDetailAboutCell, pageIndex: Int, isRreshing: Bool, pageSize: Int) {
        let params = ["brandId": productModel?.brandId ?? 0, "currentPage": pageIndex,"pageSize":pageSize, "excludes": [productModel?.productId ?? 0]]
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_ProductBrand(params: params as? [String : AnyObject]), successClosure: {[weak self] (result) in
            
            if let strongSelf = self {
                productDetailAboutCell.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    strongSelf.aboutProductArray.appendContentsOf(array)
                    productDetailAboutCell.dataArr?.appendContentsOf(array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < productDetailAboutCell.pageSize {
                        productDetailAboutCell.collectionView.xzm_footer = nil
                        //如果没有数据了就设为false，防止cell重用会出错，一直显示可以刷新
                        strongSelf.noMoreData = false
                        
                    }else {
                        productDetailAboutCell.collectionView.xzm_footer = productDetailAboutCell.xzm_footer
                    }
                    
                }else {
                    
                    productDetailAboutCell.collectionView.xzm_footer = nil
                    strongSelf.noMoreData = false

                }
                productDetailAboutCell.collectionView.reloadData()
                
                

            }
            
        }) { (errorMsg) in
            
                productDetailAboutCell.collectionView.xzm_footer = nil
                productDetailAboutCell.endRefresh()
            
        }
        
    }
    func selectCollectionIndex(productId: Int) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWProductDetailController)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = productId
        navigationController?.pushViewController(vc, animated: true)
    }

}


extension WOWProductDetailController {
    func setPhoto() -> [PhotoModel] {
        var photos: [PhotoModel] = []
        
        for  aa:WOWProductPicTextModel in productModel?.secondaryImgs ?? [WOWProductPicTextModel](){
            
            if let imgStr = aa.image{
                
                let photoModel = PhotoModel(imageUrlString: imgStr, sourceImageView: nil)
                photos.append(photoModel)
            }
        }
        
        
        return photos
    }
    
    func lookBigImg(beginPage:Int)  {
        dispatch_async(dispatch_get_main_queue()) {
            let photoBrowser = PhotoBrowser(photoModels:self.setPhoto()) {[weak self] (extraBtn) in
                if let sSelf = self {
                    let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (sSelf.view.zj_height - 80)*0.5, width: sSelf.view.zj_width, height: 80.0))
                    sSelf.view.addSubview(hud)
                }
                
            }
            // 指定代理
            photoBrowser.show(inVc: self, beginPage: beginPage)
            
        }
        
    }

}

