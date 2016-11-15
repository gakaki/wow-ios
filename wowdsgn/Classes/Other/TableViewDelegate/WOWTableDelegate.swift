//
//  WOWTableDelegate.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/9.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWTableDelegate: NSObject,UITableViewDelegate,UITableViewDataSource {
    open var vc : UIViewController?
    open var cell_heights            = [0:0.h]
    open var dataSourceArray    = [WOWHomeModle]()// 主页main的数据源
    open var isOverBottomData :Bool? //底部列表数据是否拿到全部
    open var bottomListArray    = [WOWProductModel](){//底部列表数组 ,如果有底部瀑布流的话
        didSet{
            
            bottomListCount = bottomListArray.count
            bottomCellLine  = bottomListCount.getParityCellNumber()
        }
    }
    open var bottomListCount    = 0 // 底部数组个数
    open var bottomCellLine     = 0 // 底部cell number
    open var record_402_index   = [Int]()// 记录tape 为402 的下标，方便刷新数组里的喜欢状态
    
    open var tableView :UITableView!{
        didSet{
            
            tableView.delegate    = self
            tableView.dataSource  = self
            tableView.register(UINib.nibName(String(describing: WOWHotStyleCell.self)), forCellReuseIdentifier:HomeCellType.cell_701)
            
            tableView.register(UINib.nibName(HomeCellType.cell_201), forCellReuseIdentifier:HomeCellType.cell_201)
            
            tableView.register(UINib.nibName(HomeCellType.cell_601), forCellReuseIdentifier: HomeCellType.cell_601)
            
            tableView.register(UINib.nibName(HomeCellType.cell_101), forCellReuseIdentifier: HomeCellType.cell_101)
            
            tableView.register(UINib.nibName(HomeCellType.cell_103), forCellReuseIdentifier: HomeCellType.cell_103)
            
            tableView.register(UINib.nibName(HomeCellType.cell_102), forCellReuseIdentifier: HomeCellType.cell_102)
            
            tableView.register(UINib.nibName(HomeCellType.cell_HomeList), forCellReuseIdentifier: HomeCellType.cell_HomeList)
            
            for (k,c) in ModulePageType.d {
                if c is ModuleViewElement.Type {
                    let cell            = (c as! ModuleViewElement.Type)
                    let isNib           = cell.isNib()
                    let cellName        = String(describing: cell)
                    let identifier      = "\(k)"
                    if (isNib == true){
                        tableView.register(UINib.nibName(cellName), forCellReuseIdentifier:identifier)
                    }else{
                        tableView.register(c.self, forCellReuseIdentifier:identifier)
                    }
                    print("\(k) = \(c)")
                }
            }
            
            
            tableView.backgroundColor = GrayColorLevel5
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 410
            tableView.separatorColor     = SeprateColor
            NotificationCenter.default.addObserver(self, selector:#selector(refreshData), name:NSNotification.Name(rawValue: WOWRefreshFavoritNotificationKey), object:nil)

        }
    }
    
    // 刷新物品的收藏状态与否 传productId 和 favorite状态
    func refreshData(_ sender: Notification)  {
        
        if  let send_obj =  sender.object as? [String:AnyObject] {
            
            bottomListArray.ergodicArrayWithProductModel(dic: send_obj)
            
            for j in record_402_index { // 遍历自定义产品列表，确保刷新喜欢状态
                let model = dataSourceArray[j]
                model.moduleContentProduct?.products?.ergodicArrayWithProductModel(dic: send_obj)
            }
            self.tableView.reloadData()
        }
        
    }

    // 配置cell的UI
    func cellUIConfig(one: NSInteger, two: NSInteger ,isHiddenTwoItem: Bool, cell:HomeBottomCell,dataSourceArray:[WOWProductModel])  {
        let  modelOne = dataSourceArray[one]
        if isHiddenTwoItem == false {
            
            cell.showDataOne(modelOne)
            cell.twoLb.isHidden = false
            
        }else{
            
            let  modelTwo = dataSourceArray[two]
            cell.showDataOne(modelOne)
            cell.showDataTwo(modelTwo)
            cell.twoLb.isHidden = true
        }
        
        cell.oneBtn.tag = one
        cell.twoBtn.tag = two
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataSourceArray.count + bottomCellLine
        
    }
    func getCellHeight(_ sectionIndex:Int) -> CGFloat{
        if let h = cell_heights[sectionIndex] {
            return h
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //
    //        return getCellHeight(indexPath.section)
    //
    //    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let section     = (indexPath as NSIndexPath).section
    //        if section < dataSourceArray.count {
    //            let model = dataSourceArray[section]
    //            switch model.moduleType ?? 0 {
    //            case 402:
    //
    //            default:
    //
    //            }
    //        }
    //
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dataSourceArray.count {
            let model = dataSourceArray[section]
            
            
            switch model.moduleType ?? 0 {
            case 402:
                
                record_402_index.append(section)
                
                let array = model.moduleContentProduct?.products ?? []
                return (array.count.getParityCellNumber()) > 10 ? 10: (array.count.getParityCellNumber())
                
            default:
                
                return 1
                
            }
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell:UITableViewCell!
        let section     = (indexPath as NSIndexPath).section
        guard (indexPath as NSIndexPath).section < dataSourceArray.count  else {
            let cell                = tableView.dequeueReusableCell(withIdentifier: "HomeBottomCell", for: indexPath) as! HomeBottomCell
            
            cell.indexPath = indexPath
            
            let OneCellNumber = ((indexPath as NSIndexPath).section  - dataSourceArray.count + 0) * 2
            let TwoCellNumber = (((indexPath as NSIndexPath).section  - dataSourceArray.count + 1) * 2) - 1
            if bottomListCount.isOdd && (indexPath as NSIndexPath).section + 1 == (dataSourceArray.count) + bottomListCount.getParityCellNumber() {//  满足为奇数 第二个item 隐藏
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:bottomListArray)
                
            }else{
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:bottomListArray)
                
            }
            
            cell.delegate = self.vc as! HomeBottomDelegate?
            cell.selectionStyle = .none
            cell_heights[section]  = cell.heightCell
            returnCell = cell
            return returnCell
            
        }
        
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        let identifier  = "\(model.moduleType!)"
        switch model.moduleType ?? 0 {
        case 701:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier:HomeCellType.cell_701 , for: indexPath) as! WOWHotStyleCell
            
            cell.modelData = model.moduleContentList
            cell.showData(model: model)
            cell.delegate = self.vc as! WOWHotStyleCellDelegate?
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 201:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_201, for: indexPath) as! WOWlListCell
            
            cell.delegate       = self.vc as! SenceCellDelegate?
            cell.showData(model.moduleContent!)
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 601:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_601, for: indexPath) as! WOWHomeFormCell
            
            cell.indexPathSection = indexPath.section
            cell.delegate         = self.vc as! WOWHomeFormDelegate?
            cell.modelData        = model.moduleContentList
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 101:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_101, for: indexPath) as! HomeBrannerCell
            
            if let banners = model.moduleContent?.banners{
                
                cell.reloadBanner(banners)
                cell.cyclePictureView.delegate = self.vc as! CyclePictureViewDelegate?
                
            }
            cell_heights[section]  = cell.heightAll
            returnCell = cell
            
        case 102:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_102, for: indexPath) as! Cell_102_Project
            cell.dataArr = model.moduleContent?.banners
            cell.lbTitle.text = model.moduleContent?.name ?? "专题"
            cell.delegate = self.vc as! cell_102_delegate?
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 801:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_103, for: indexPath) as! Cell_103_Product
            let array = model.moduleContentProduct?.products
            cell.dataSourceArray = array
            cell.delegate = self.vc as! cell_801_delegate?
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 402:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_402, for: indexPath) as! HomeBottomCell
            cell.indexPath = indexPath
            
            let OneCellNumber = indexPath.row * 2
            let TwoCellNumber = ((indexPath.row + 1) * 2) - 1
            let productsArray = model.moduleContentProduct?.products ?? []
            
            if productsArray.count.isOdd && (indexPath as NSIndexPath).row + 1 == productsArray.count.getParityCellNumber(){ //  满足为奇数 第二个item 隐藏
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:productsArray)
                
            }else{
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:productsArray)
                
            }
            // 排序 0，1，2，3，4...
            cell.delegate = self.vc as! HomeBottomDelegate?
            
            returnCell = cell
            
        case  Cell_302_Class.cell_type():
            
            let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! Cell_302_Class
            cell.setData( model.moduleContentArr ?? [WowModulePageItemVO]() )
            
            cell.delegate = self.vc as! Cell_302_Delegate?
            cell.bringSubview(toFront: cell.cv)
            
            returnCell = cell
            //                return cell
            
        case WOWFoundWeeklyNewCell.cell_type():
            
            let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! WOWFoundWeeklyNewCell
            cell.setData( model.moduleContentArr ?? [WowModulePageItemVO]())
            cell_heights[section]  = cell.heightAll
            cell.delegate = self.vc as! FoundWeeklyNewCellDelegate?
            cell.bringSubview(toFront: cell.cv)
            
            returnCell = cell
            
            
        case Cell_501_Recommend.cell_type():
            
            let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! Cell_501_Recommend
            cell.delegate       = self.vc as! Cell_501_Delegate?
            cell.showData(model.moduleContentItem!)
            
            returnCell = cell
        case MODULE_TYPE_CATEGORIES_CV_CELL_301.cell_type():
            
            let cell            = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! MODULE_TYPE_CATEGORIES_CV_CELL_301
            
            cell.delegate       = self.vc as! MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate?
            cell.setData(model.moduleContentArr ?? [WowModulePageItemVO]())
            cell_heights[section]  = cell.heightAll
            cell.bringSubview(toFront: cell.collectionView)
            
            returnCell = cell
            
            
        default:
            returnCell = UITableViewCell()
            break
        }
        returnCell.selectionStyle = .none
        
        return returnCell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if bottomListCount > 0 {
            guard section < dataSourceArray.count  else {
                
                if section == ((dataSourceArray.count ) + bottomCellLine) - 1{
                                    if isOverBottomData == true {
                                        return 70
                                    }
                }
                return CGFloat.leastNormalMagnitude
            }
            return 15.h
        }
        if section == dataSourceArray.count - 1{
            return 70.h
        }else{
            return 15.h
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if bottomListCount > 0 {
            guard section < dataSourceArray.count  else {
                
                if section == ((dataSourceArray.count ) + bottomCellLine) - 1{
                                    if isOverBottomData == true {
                                        return footerView()
                                    }
                }
                return nil
            }
            return nil
        }
        
        if section == dataSourceArray.count - 1{
            return footerView()
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
        case dataSourceArray.count:
            return 70
        default:
            if section < dataSourceArray.count{
                
                let model = dataSourceArray[section]
                
                switch model.moduleType ?? 0 {
                case 402,301,501,401:
                    
                    return 50
                case 302:
                    
                    return 15
                    
                default:
                    
                    return CGFloat.leastNormalMagnitude
                    
                }
                
            }
            
            return CGFloat.leastNormalMagnitude
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case dataSourceArray.count:
            return hearderView()
        default:
            if section < dataSourceArray.count{
                
                let model = dataSourceArray[section]
                var t = "本周上新"
                var isHiddenLien = false
                switch model.moduleType ?? 0 {
                    
                case 402:
                    isHiddenLien = false
                    t           =  model.moduleContentProduct?.name ?? "居家好物"
                case 501:
                    isHiddenLien = true
                    t           = "单品推荐"
                case 301:
                    isHiddenLien = true
                    t           = "场景"
                case 401:
                    isHiddenLien = true
                    t           = model.name ?? "本周上新"
                default:
                    isHiddenLien = false
                    t = ""
                    
                }
                if t.isEmpty {
                    return nil
                }else {
                    return WOW_Cell_402_Hearder(title: t,isHiddenLine: isHiddenLien)
                }
            }
            
            return nil
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.vc?.className == "WOWController" {
            let wowcontroller  = self.vc as? WOWController
            if scrollView.mj_offsetY < wowcontroller?.backTopBtnScrollViewOffsetY {
                wowcontroller?.topBtn.isHidden = true
            }else{
                wowcontroller?.topBtn.isHidden = false
            }
        }
       
        
    }

    func footerView() -> UIView {
        
        let view = WOWDSGNFooterView.init(frame: CGRect(x: 0, y: 0, width: MGScreenWidth,height: 70.h))
        view.backgroundColor = tableView?.backgroundColor
        return view
        
    }
    func hearderView() -> UIView { // 137 37
        
        let view = WOWHearderView.init(frame: CGRect(x: 0, y: 0, width: MGScreenWidth,height: 70))
        return view
        
    }
    func WOW_Cell_402_Hearder(title: String,isHiddenLine:Bool) -> UIView {
        
        let v = Bundle.main.loadNibNamed("WOW_Cell_402_Hearder", owner: self, options: nil)?.last as! WOW_Cell_402_Hearder
        v.frame = CGRect(x: 0, y: 0, width: MGScreenWidth,height: 50)
        v.lbTitle.text = title
        if isHiddenLine{
            v.lbLine.isHidden = true
        }else{
            v.lbLine.isHidden = false
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section < dataSourceArray.count  else {
            return
        }
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        switch model.moduleType ?? 0{
        case 201://单个图片
            if let modelBanner = model.moduleContent {
                
                let v = self.vc as? WOWBaseModuleVC
                v?.goController(modelBanner)
                
            }
        case 701:
            let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
            //                vc.hideNavigationBar = true
            vc.topic_id = model.moduleContentList?.id ?? 0
            vc.delegate = self.vc as! WOWHotStyleDelegate?
            
            self.vc?.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        
        
    }
    
}
