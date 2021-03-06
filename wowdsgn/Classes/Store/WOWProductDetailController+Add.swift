


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
        tableView.register(UINib.nibName(String(describing: WOWProductDetailPriceCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailPriceCell.self))
        //限购标签
        tableView.register(UINib.nibName(String(describing: WOWProductLimitCell.self)), forCellReuseIdentifier:String(describing: WOWProductLimitCell.self))
        //促销标签
        tableView.register(UINib.nibName(String(describing: WOWProductPromotionCell.self)), forCellReuseIdentifier:String(describing: WOWProductPromotionCell.self))
        //产品包邮说明
        tableView.register(UINib.nibName(String(describing: WOWProductDesCell.self)), forCellReuseIdentifier:String(describing: WOWProductDesCell.self))
        //品牌故事
        tableView.register(UINib.nibName(String(describing: WOWProductDetailDescCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailDescCell.self
        ))
        //产品描述
        tableView.register(UINib.nibName(String(describing: WOWProductDetailCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailCell.self))
        //产品参数
        tableView.register(UINib.nibName(String(describing: WOWProductParamCell.self)), forCellReuseIdentifier:String(describing: WOWProductParamCell.self))
        //温馨提示
        tableView.register(UINib.nibName(String(describing: WOWProductDetailTipsWebViewCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailTipsWebViewCell.self))
        //客服电话
        tableView.register(UINib.nibName(String(describing: WOWTelCell.self)), forCellReuseIdentifier:String(describing: WOWTelCell.self))
        //评论与晒单
        tableView.register(UINib.nibName(String(describing: WOWProductCommentCell.self)), forCellReuseIdentifier:String(describing: WOWProductCommentCell.self))
        //相关商品
        tableView.register(UINib.nibName(String(describing: WOWProductDetailAboutCell.self)), forCellReuseIdentifier:String(describing: WOWProductDetailAboutCell.self))
        //税率说明
        tableView.register(UINib.nibName(String(describing: WOWTaxExplainCell.self)), forCellReuseIdentifier:String(describing: WOWTaxExplainCell.self))
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3 + isOversea + isHaveLimit + isHavePromotion:   //产品图文详情
            return productModel?.secondaryImgs?.count ?? 0
        case 4 + isOversea + isHaveLimit + isHavePromotion: //产品参数可展开
            if isOpenParam {
                return productModel?.productParameter?.count ?? 0
            }else {
                return 0
            }
        case 5 + isOversea + isHaveLimit + isHavePromotion: //温馨提示也可展开
            if isOpenTips {
                return 1
            }else {
                return 0
            }
        case 6 + isOversea + isHaveLimit + isHavePromotion + isHaveComment: //商品评论
            if isHaveComment == 1 {
                return commentList.count > 3 ? 3 : commentList.count

            }else {
                return 1
            }
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        
        switch ((indexPath as NSIndexPath).section,(indexPath as NSIndexPath).row) {
        case (0,_): //标题价钱
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductDetailPriceCell.self), for: indexPath) as! WOWProductDetailPriceCell
            cell.showData(productModel)
            returnCell = cell
            
        case (0 + isHaveLimit,_): //限购标签
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductLimitCell.self), for: indexPath) as! WOWProductLimitCell
            cell.limitLabel.text = productModel?.limitTag ?? ""
            returnCell = cell
            
        case (0 + isHaveLimit + isHavePromotion,_): //促销标签
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductPromotionCell.self), for: indexPath) as! WOWProductPromotionCell
            cell.promotionTag.text = promotionTag
            cell.promotionTime.text = promotionTime
            returnCell = cell
            
        case (1 + isHaveLimit + isHavePromotion,_): //满199包邮
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductDesCell.self), for: indexPath) as! WOWProductDesCell
            cell.showData(productModel)
            returnCell = cell
            
        case (1 + isOversea + isHaveLimit + isHavePromotion,_): //海购说明
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTaxExplainCell.self), for: indexPath) as! WOWTaxExplainCell
            cell.showData(productModel?.logisticsMode)
            returnCell = cell
            
        case (2 + isOversea + isHaveLimit + isHavePromotion,_): //品牌设计师
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductDetailDescCell.self), for: indexPath) as! WOWProductDetailDescCell
            cell.showData(self.productModel)
            returnCell = cell
            
        case (3 + isOversea + isHaveLimit + isHavePromotion,_): //产品描述
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductDetailCell.self), for: indexPath) as! WOWProductDetailCell
            if let array = productModel?.secondaryImgs {
                let model = array[(indexPath as NSIndexPath).row]
                cell.showData(model)
                cell.productImg.tag = (indexPath as NSIndexPath).row
                cell.productImg.addTapGesture(action: {[weak self] (tap) in
                    if let strongSelf = self {
                        strongSelf.lookBigImg((tap.view?.tag) ?? 0)
                    }
                    
                    })
            }
            
            returnCell = cell
            
        case (4 + isOversea + isHaveLimit + isHavePromotion,_): //参数
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductParamCell.self), for: indexPath) as! WOWProductParamCell
            
            if let parameter = productModel?.productParameter {
                cell.showData(parameter[indexPath.row])
            }
            
            returnCell = cell
            
        case (5 + isOversea + isHaveLimit + isHavePromotion,_)://温馨提示
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWProductDetailTipsWebViewCell", for: indexPath) as! WOWProductDetailTipsWebViewCell
            cell.showData(productModel)
            returnCell = cell
            
        case (6 + isOversea + isHaveLimit + isHavePromotion,_): //客服电话
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWTelCell.self), for: indexPath) as! WOWTelCell

            cell.contentView.addTapGesture {[unowned self] (sender) in
                
                WOWCustomerNeedHelp.shareBackView.showNeedHelp()
                WOWCustomerNeedHelp.shareBackView.shareActionBack = {(shareType:WOWShareType) in
                    switch shareType {
                    case .needPhone:
                        WOWTool.callPhone()
                        return
                    case .needCustomer:
                        self.gotoCustomerVC()
                        return
                        default:break
                    }
                }
            }
            returnCell = cell
            
        case (6 + isOversea + isHaveLimit + isHavePromotion + isHaveComment,_): //商品评论
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: String(describing: WOWProductCommentCell.self), for: indexPath) as! WOWProductCommentCell
            cell.showData(model: commentList[indexPath.row])
            cell.delegate = self
            returnCell = cell
            
        case (6 + isOversea + isHaveLimit + isHavePromotion + isHaveAbout + isHaveComment,_)://相关商品
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWProductDetailAboutCell", for: indexPath) as! WOWProductDetailAboutCell
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
            
        case 3 + isOversea + isHaveLimit + isHavePromotion:
            
            //动态获取产品描述的label高度
            return 67 + productDescView.productDescLabel.getEstimatedHeight()
            
        case 4 + isOversea + isHaveLimit + isHavePromotion, 5 + isOversea  + isHaveLimit + isHavePromotion:
            //产品参数与温馨提示cell头
            return 60
            
        case 6 + isOversea + isHaveLimit + isHavePromotion + isHaveComment:       //商品评价
            
            if isHaveComment == 1 {
                return 60
            }else {
                return 0.01
            }
            
        case 6 + isOversea + isHaveLimit + isHavePromotion + isHaveComment + isHaveAbout: //如果相关商品有数据显示，如果没有就不显示
            
            if aboutProductArray.count > 0 {
                return 39
            }else {
                return 0.01
            }
            
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            
        case 0: //商品价格
            
            return 0.01
            
        case 0 + isHaveLimit : //限购标签
            
            return 0.01
            
        case 0 + isHaveLimit + isHavePromotion: //促销标签
            
            return 0.01
            
        case 4 + isOversea + isHaveLimit + isHavePromotion:   //产品参数
            
            if isOpenParam {
                return 20
            }else {
                return 0.01
            }
            
        case 6 + isOversea + isHaveLimit + isHavePromotion:  //客服电话
            
            return 0.01
            
        case 6 + isOversea + isHaveLimit + isHavePromotion + isHaveComment:       //商品评价
            
            return 0.01
            
        default:
            
            return 10
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
            
        case 3 + isOversea + isHaveLimit + isHavePromotion:     //产品描述
            
            return productDescView
            
        case 4 + isOversea + isHaveLimit + isHavePromotion:   //产品参数
            
            paramView.label.text = "产品参数"
            paramView.openImg.addTapGesture(action: { [weak self](tap) in
                if let strongSelf = self  {
                    strongSelf.isOpenParam = !strongSelf.isOpenParam
                    strongSelf.paramView.isOpen(strongSelf.isOpenParam)
                    let sections = NSIndexSet(index: section)
                    tableView.reloadData()
                }
                })
            return paramView
            
        case 5 + isOversea + isHaveLimit + isHavePromotion:   //温馨提示
            
            tipsView.label.text = "温馨提示"
            tipsView.openImg.addTapGesture(action: { [weak self](tap) in
                if let strongSelf = self  {
                    strongSelf.isOpenTips = !strongSelf.isOpenTips
                    strongSelf.tipsView.isOpen(strongSelf.isOpenTips)
                    let sections = NSIndexSet(index: section)
                    tableView.reloadData()
                }
                })
            return tipsView
            
        case 6 + isOversea + isHaveLimit + isHavePromotion + isHaveComment: //相关商品
            
            if isHaveComment == 1 {
                return commentView
            }else {
                return nil
            }
            
        case 6 + isOversea + isHaveLimit + isHavePromotion + isHaveAbout + isHaveComment: //相关商品
            
            if aboutProductArray.count > 0 {
                return aboutView
            }else {
                return nil
            }
            
        default:
            
            return nil
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        if section == 4 + isOversea + isHaveLimit + isHavePromotion { //产品参数
            view.backgroundColor = UIColor.white
        }
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch (indexPath as NSIndexPath).section {
            
        case 6 + isOversea + isHaveLimit + isHavePromotion:   //客服电话
            
            WOWTool.callPhone()
            
        default:
            break
        }
    }
    
}

extension WOWProductDetailController: WOWProductDetailAboutCellDelegate {
    
    func aboutProduct(_ productDetailAboutCell:WOWProductDetailAboutCell, pageIndex: Int, isRreshing: Bool, pageSize: Int) {
        
        let params = ["productId": productModel?.productId ?? 0, "currentPage": pageIndex,"pageSize":pageSize] as [String : Any]
        
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductAbout(params: params as [String : AnyObject]), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self {
                productDetailAboutCell.endRefresh()
                
                let arr = Mapper<WOWProductModel>().mapArray(JSONObject:JSON(result)["productVoList"].arrayObject)
                
                if let array = arr{
                    strongSelf.aboutProductArray.append(contentsOf: array)
                    productDetailAboutCell.dataArr?.append(contentsOf: array)
                    
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
            WOWHud.showWarnMsg(errorMsg)
        }
        
    }
    
    func selectCollectionIndex(_ productId: Int) {
        
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
        vc.hideNavigationBar = true
        vc.productId = productId
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


extension WOWProductDetailController: WOWProductCommentCellDelegate {
    
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
    
    func lookBigImg(_ beginPage:Int)  {
        
        DispatchQueue.main.async {
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
    //delegate
    func lookBigImage(_ index: Int, array imgArr: Array<String>) {
        loadBigImage(imgArr, index)
    }
    
}

