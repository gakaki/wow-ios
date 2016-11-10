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
    
    open var dataSourceArray    = [WOWHomeModle]()// 主页main的数据源
    
    open var bottomListArray    = [WOWProductModel](){//底部列表数组 ,如果有底部瀑布流的话
        didSet{
            bottomListCount = bottomListArray.count
            bottomCellLine  = bottomListCount.getParityCellNumber()
        }
    }
    open var bottomListCount    = 0 // 底部数组个数
    open var bottomCellLine     = 0 // 底部cell number
    
    
    open var tableView :UITableView?{
        didSet{
            
            tableView?.delegate = self
            tableView?.register(UINib.nibName(String(describing: WOWHotStyleCell.self)), forCellReuseIdentifier:HomeCellType.cell_701)
            
            tableView?.backgroundColor = GrayColorLevel5
            tableView?.rowHeight = UITableViewAutomaticDimension
            tableView?.estimatedRowHeight = 410
            

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dataSourceArray.count {
            let model = dataSourceArray[section]
            
            switch model.moduleType ?? 0 {
            case 402:
//                record_402_index.append(section)
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
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        switch model.moduleType ?? 0 {
        case 701:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier:HomeCellType.cell_701 , for: indexPath) as! WOWHotStyleCell
            
            cell.modelData = model.moduleContentList
            cell.showData(model: model)
            cell.delegate = self.vc as! WOWHotStyleCellDelegate?
            
            returnCell = cell
        case 201:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_201, for: indexPath) as! WOWlListCell
            
            cell.delegate       = self.vc as! SenceCellDelegate?
            cell.showData(model.moduleContent!)
            
            returnCell = cell
        case 601:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_601, for: indexPath) as! WOWHomeFormCell
            
            cell.indexPathSection = indexPath.section
            cell.delegate         = self.vc as! WOWHomeFormDelegate?
            cell.modelData        = model.moduleContentList
            
            returnCell = cell
        case 101:
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_101, for: indexPath) as! HomeBrannerCell
            
            if let banners = model.moduleContent?.banners{
                
                cell.reloadBanner(banners)
                cell.cyclePictureView.delegate = self.vc as! CyclePictureViewDelegate?
           
            }
            
            returnCell = cell
            
        case 102:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_102, for: indexPath) as! Cell_102_Project
            cell.dataArr = model.moduleContent?.banners
            cell.lbTitle.text = model.moduleContent?.name ?? "专题"
            cell.delegate = self.vc as! cell_102_delegate?
           
            returnCell = cell
        case 801:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: HomeCellType.cell_103, for: indexPath) as! Cell_103_Product
            let array = model.moduleContentProduct?.products
            cell.dataSourceArray = array
            cell.delegate = self.vc as! cell_801_delegate?
            
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

        default:
            break
        }
        returnCell.selectionStyle = .none
        return returnCell

    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if bottomListCount > 0 {
        guard section < dataSourceArray.count  else {
            
            if section == ((dataSourceArray.count ) + bottomCellLine) - 1{
//                if isOverBottomData == true {
//                    return 70
//                }
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
//                if isOverBottomData == true {
//                    return footerView()
//                }
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
                case 402:
                    
                    return 50
                    
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
                
                switch model.moduleType ?? 0 {
                case 402:
                    
                    return WOW_Cell_402_Hearder(title: model.moduleContentProduct?.name ?? "居家好物")
                    
                default:
                    
                    return nil
                    
                }
                
            }
            
            return nil
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
    func WOW_Cell_402_Hearder(title: String) -> UIView {
        
        let v = Bundle.main.loadNibNamed("WOW_Cell_402_Hearder", owner: self, options: nil)?.last as! WOW_Cell_402_Hearder
        v.frame = CGRect(x: 0, y: 0, width: MGScreenWidth,height: 50)
        v.lbTitle.text = title
        return v
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
        //                vc.hideNavigationBar = true
        vc.topic_id = model.moduleContentList?.id ?? 0
        vc.delegate = self.vc as! WOWHotStyleDelegate?
        
       self.vc?.navigationController?.pushViewController(vc, animated: true)

    }

}
