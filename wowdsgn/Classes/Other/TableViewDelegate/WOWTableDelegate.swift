//
//  WOWTableDelegate.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/9.
//  Copyright © 2016年 g. All rights reserved.
//
enum ControllerViewType { // 区分底部列表
    case Home         // 首页
    case Buy          // 购物页
    case HotStyle     // 精选页
}
import UIKit
import UITableView_FDTemplateLayoutCell
class WOWTableDelegate: NSObject,UITableViewDelegate,UITableViewDataSource,CyclePictureViewDelegate {
    open var vc : UIViewController?

    open var ViewControllerType  :ControllerViewType?
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮
    open var cell_heights    = [0:0.h]
    open var dataSourceArray = [WOWHomeModle]()// 主页main的数据源
    open var isOverBottomData :Bool? //底部列表数据是否拿到全部
    open var bottomHotListArray = [WOWHotStyleModel]() {//精选底部列表数组
        didSet{
            
            bottomCellLine = bottomHotListArray.count

        }

    }
    open var bottomListArray    = [WOWProductModel](){//底部列表数组 ,如果有底部瀑布流的话
        didSet{
            
            bottomListCount = bottomListArray.count
            bottomCellLine  = bottomListCount.getParityCellNumber()
        }
    }
    open var bottomListCount    = 0 // 底部数组个数
    open var bottomCellLine     = 0 // 底部cell number
    open var record_402_index   = [Int]()// 记录tape 为402 的下标，方便刷新数组里的喜欢状态
    open var bannerArray = [WOWCarouselBanners]() //顶部轮播图数组
    open var tableView :UITableView!{

        didSet{
            self.tableView.register(UINib.nibName("WOWHotMainCell"), forCellReuseIdentifier: "WOWHotMainCell")
            self.tableView.register(UINib.nibName("HomeBottomCell"), forCellReuseIdentifier: "HomeBottomCell")
            
            for (k,c) in ModulePageType.d {
                if c is ModuleViewElement.Type {
                    let cell            = (c as! ModuleViewElement.Type)
                    let isNib           = cell.isNib()
                    let cellName        = String(describing: cell)// 以类名作为Identtifier
                    if (isNib == true){
                        self.tableView.register(UINib.nibName(cellName), forCellReuseIdentifier:cellName)
                    }else{
                        self.tableView.register(c.self, forCellReuseIdentifier:cellName)
                    }
                    print("\(k) = \(c)")
                }
            }

            self.tableView.backgroundColor    = self.vc?.view.backgroundColor
            self.tableView.rowHeight          = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 410
            self.tableView.delegate           = self
            self.tableView.dataSource         = self
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
        
        return dataSourceArray.count + bottomCellLine// 主数据源 + 底部数据 （如果底部数据有的话）
        
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
//        let section     = (indexPath as NSIndexPath).section
//        if section < dataSourceArray.count {
//            let model = dataSourceArray[section]
//            let type = model.moduleType ?? 0
//            let identifier  = ModulePageType.getIdentifier(type)
//            switch type {
//            case 301,401,801:// AutoLayout 不完整，给指定数
//                return getCellHeight(section)
//            
//            default:
//                return tableView.fd_heightForCell(withIdentifier: identifier , configuration: { (cell) in
//                    
//                })
//            }
//            
//        }else{
//            
//            return tableView.fd_heightForCell(withIdentifier: "HomeBottomCell" , configuration: { (cell) in
//                
//            })
//        }
//        
//        
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dataSourceArray.count {
            let model = dataSourceArray[section]
            
            
            switch model.moduleType ?? 0 {
            case 402:// 多行展示
                record_402_index.removeObject(section)
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
            switch ViewControllerType ?? .Home { // 底部列表是首页的，还是精选页的
            case .Home:
                let cell                = tableView.dequeueReusableCell(withIdentifier: "HomeBottomCell", for: indexPath) as! HomeBottomCell
                
                cell.indexPath = indexPath
                
                let OneCellNumber = ((indexPath as NSIndexPath).section  - dataSourceArray.count + 0) * 2
                let TwoCellNumber = (((indexPath as NSIndexPath).section  - dataSourceArray.count + 1) * 2) - 1
                if bottomListCount.isOdd && (indexPath as NSIndexPath).section + 1 == (dataSourceArray.count) + bottomListCount.getParityCellNumber() {//  满足为奇数 第二个item 隐藏
                    
                    self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:bottomListArray)
                    
                }else{
                    
                    self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:bottomListArray)
                    
                }
                
                cell.delegate         = self.vc as! HomeBottomDelegate?
                cell.selectionStyle   = .none
                cell_heights[section] = cell.heightCell
                returnCell            = cell
                return returnCell
                
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotMainCell", for: indexPath) as! WOWHotMainCell
                let sectionIndex = section - dataSourceArray.count
                let model = bottomHotListArray[sectionIndex]
                cell.showData(model)
                cell.selectionStyle   = .none
                return cell
            }
            
        }
        
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        
        let type = model.moduleType ?? 0
        let identifier  = ModulePageType.getIdentifier(type) // 获取对应Type的className
        switch type {
        case 701:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier:identifier , for: indexPath) as! WOWHotStyleCell
            
            cell.modelData = model.moduleContentList
            cell.showData(model: model)
            cell.delegate  = self.vc as! WOWHotStyleCellDelegate?
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 201:
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WOWlListCell
            
            cell.delegate = self.vc as! SenceCellDelegate?
            cell.showData(model.moduleContent!)
            cell.model = model.moduleContent!
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 601:
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WOWHomeFormCell
            
            cell.indexPathSection = indexPath.section
            cell.delegate         = self.vc as! WOWHomeFormDelegate?
            cell.modelData        = model.moduleContentList
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 101:
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeBrannerCell
            
            if let banners = model.moduleContent?.banners{
                
                cell.reloadBanner(banners)
                self.bannerArray = banners
                cell.cyclePictureView.delegate = self
            }
            cell_heights[section]  = cell.heightAll
            returnCell = cell
            
        case 102:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell_102_Project
            cell.dataArr      = model.moduleContent?.banners
//            cell.lbTitle.text = model.moduleContent?.name ?? "专题"
            cell.delegate     = self.vc as! cell_102_delegate?
            cell_heights[section]  = cell.heightAll
            returnCell = cell
        case 801:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell_801_Product
            let array            = model.moduleContentProduct?.products
            cell.dataSourceArray = array
            cell.delegate        = self.vc as! cell_801_delegate?
            cell_heights[section]  = cell.heightAll
            cell.currentSingTodayName = model.moduleContentProduct?.name ?? "今日单品"
            returnCell = cell
        case 402:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeBottomCell
            cell.indexPath = indexPath
            
            let OneCellNumber = indexPath.row * 2
            let TwoCellNumber = ((indexPath.row + 1) * 2) - 1
            let productsArray = model.moduleContentProduct?.products ?? []
            
            if productsArray.count.isOdd && (indexPath as NSIndexPath).row + 1 == productsArray.count.getParityCellNumber(){ //  满足为奇数 第二个item 隐藏
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: false, cell: cell,dataSourceArray:productsArray)
                
            }else{
                
                self.cellUIConfig(one: OneCellNumber, two: TwoCellNumber, isHiddenTwoItem: true, cell: cell,dataSourceArray:productsArray)
                
            }
            cell.delegate = self.vc as! HomeBottomDelegate?
            
            returnCell = cell
            
        case  Cell_302_Class.cell_type():
            
            let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! Cell_302_Class
            cell.setData( model.moduleContentArr ?? [WowModulePageItemVO]() )
            
            cell.delegate = self.vc as! Cell_302_Delegate?
            cell.bringSubview(toFront: cell.cv)
            
            returnCell = cell
            
            
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
        
        case Cell_104_TwoLine.cell_type():
            let cell            = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! Cell_104_TwoLine
            
            cell.delegate       = self.vc as! Cell_104_TwoLineDelegate?
//            cell.setData(model.moduleContent?.banners ?? [WOWCarouselBanners]())
            cell.dataArr = model.moduleContent?.banners ?? [WOWCarouselBanners]()
//            cell_heights[section]  = cell.heightAll
//            cell.bringSubview(toFront: cell.collectionView)
            returnCell = cell
            
        case WOWHotColumnCell.cell_type():
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotColumnCell", for: indexPath) as! WOWHotColumnCell
            cell.delegate = self.vc as? WOWHotColumnDelegate
            cell.dataArr  = model.moduleContentTitle?.columns
            returnCell = cell
            
        case WOWHotPeopleCell.cell_type():
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotPeopleCell", for: indexPath) as! WOWHotPeopleCell
            
            if let arr = model.moduleContentTitle?.tags{
                cell.showData(arr)
                cell.lbTitle.text = model.moduleContentTitle?.name
            }
            cell.delegate = self.vc as? HotPeopleTitleDelegate
            returnCell = cell
        case WOWHotBannerCell.cell_type():
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WOWHotBannerCell
            
            if let banners = model.moduleContent?.banners{
                
                cell.reloadBanner(banners)
                self.bannerArray = banners
                cell.cyclePictureView.delegate = self
            }

            returnCell = cell
        default:
            returnCell = UITableViewCell()
            break
        }
        returnCell.selectionStyle = .none
        
        return returnCell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

            guard section < dataSourceArray.count  else {// 说明是底部列表 section
                
                if section == ((dataSourceArray.count ) + bottomCellLine) - 1{
                    if isOverBottomData == true {// 满足最后一个cell 则显示页脚
                        return 70
                    }
                }
                switch ViewControllerType ?? .Home{
                case .Home:
                     return CGFloat.leastNormalMagnitude
                default:
                     return 15.h
                }
               
            }
        let model = dataSourceArray[section]
        switch model.moduleType ?? 0{
        case 901,1001,103:// 精选页这几个Cell UI上没有 15px
            return CGFloat.leastNormalMagnitude
        default:
             return 15.h
        }
        


    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        switch section {
        case dataSourceArray.count:
            switch ViewControllerType ?? .Home {
            case .Home:
                return 70
            default:
                return 50
            }
          
        default:
            if section < dataSourceArray.count{
                
                let model = dataSourceArray[section]
                
                switch model.moduleType ?? 0 {
                case 402,301,501,401,104,102:
                    
                    return 50
                case 302:
                    
                    return CGFloat.leastNormalMagnitude
                case 901:
                    return 55
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
            switch ViewControllerType ?? .Home {
            case .Home:
                return hearderView()
            default:
                return hearderColumnView(title: "最新")
            }

            
        default:
            if section < dataSourceArray.count{
                
                let model = dataSourceArray[section]
                var t = "本周上新"
                var isHiddenLien = false
                switch model.moduleType ?? 0 {
                case 102:
                    isHiddenLien = true
                    t            = model.moduleContent?.name ?? "专题"
                case 402:
                    isHiddenLien = false
                    t            =  model.moduleContentProduct?.name ?? "居家好物"
                    return WOW_Cell_402_Hearder(title: t,isHiddenLine: isHiddenLien,is402: true,id: model.moduleContentProduct?.id ?? 0)
                case 501:
                    isHiddenLien = true
                    t            = "单品推荐"
                case 301:
                    isHiddenLien = true
                    t            = "场景"
                case 104:
                    isHiddenLien = true
                    t            = model.moduleContent?.name ?? "推荐"
                case 401:
                    isHiddenLien = true
                    t            = model.name ?? "本周上新"
                case 901:
                    return hearderColumnView(title: model.moduleContentTitle?.name ?? "栏目")
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
    func isHiddenTopBtn(){
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        if self.vc?.className == "WOWController"  {
            let wowcontroller  = self.vc as? WOWBaseModuleVC
            if scrollView.mj_offsetY < wowcontroller?.backTopBtnScrollViewOffsetY {
                wowcontroller?.topBtn.isHidden = true
            }else{
                wowcontroller?.topBtn.isHidden = false
            }
//        }
//        if self.vc?.className == "VCFound" {
//            let wowcontroller  = self.vc as? VCFound
//            if scrollView.mj_offsetY < wowcontroller?.backTopBtnScrollViewOffsetY {
//                wowcontroller?.topBtn.isHidden = true
//            }else{
//                wowcontroller?.topBtn.isHidden = false
//            }
//
//        }
        
    }
    // 底层 wowdsgn 页脚
    func footerView() -> UIView {
        
        let view = WOWDSGNFooterView.init(frame: CGRect(x: 0, y: 0, width: MGScreenWidth,height: 70.h))
        view.backgroundColor = tableView?.backgroundColor
        return view
        
    }
    // 首页 底部列表页眉
    func hearderView() -> UIView { // 137 37
        
        let view = WOWHearderView.init(frame: CGRect(x: 0, y: 0, width: MGScreenWidth,height: 70))
        return view
        
    }
    // 尖叫栏目 页眉
    func hearderColumnView(title: String) -> UIView { // 137 37
        
        let view = Bundle.main.loadNibNamed("WOWHotHeaderView", owner: self, options: nil)?.last as! WOWHotHeaderView
        view.lbTitle.text = title
        view.lbLine.isHidden = true
        return view
        
    }
    // 类似本周上新的页眉 // 是否是 402 产品组模块， 是的话，显示更多 点击跳转对应的产品组详情页
    func WOW_Cell_402_Hearder(title: String,isHiddenLine:Bool,is402:Bool = false,id:Int = 0) -> UIView {
        
        let v = Bundle.main.loadNibNamed("WOWHotHeaderView", owner: self, options: nil)?.last as! WOWHotHeaderView
        v.frame = CGRect(x: 0, y: 0, width: MGScreenWidth,height: 50)
        v.lbTitle.text = title
        if isHiddenLine{
            v.lbLine.isHidden = true
        }else{
            v.lbLine.isHidden = false
        }
        if is402 {
            v.btnMore.isHidden = false
            v.btnMore.addAction {
                print("跳转对应的产品组的详情页\(id)")
                VCRedirect.goToProductGroup(id)
//                VCRedirect.toTopicList(topicId: id)

            }
        }else{
            v.btnMore.isHidden = true
        }
        
        return v
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath as NSIndexPath).section < dataSourceArray.count  else {
            switch ViewControllerType ?? .Home {
            case .Home:
                return
            default:
                
                let model = bottomHotListArray[indexPath.section - dataSourceArray.count]
                
                let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
                //                vc.hideNavigationBar = true
                vc.topic_id = model.id ?? 0
                
                vc.modelStyleData = model
                
                self.vc?.navigationController?.pushViewController(vc, animated: true)
                
//                self.vc?.toVCTopidDetail(model.id ?? 0)
//                self.vc?.toVCArticleListVC(model.columnId ?? 0,title: model.columnName ?? "")
            }
            return
        }
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        switch model.moduleType ?? 0{
        case 201://单个图片
            if let modelBanner = model.moduleContent {
                
                let v = self.vc as? WOWBaseModuleVC
                v?.goController(modelBanner)
                
            }
        case 701:// 精选页点赞cell
            let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
            //                vc.hideNavigationBar = true
            vc.topic_id = model.moduleContentList?.id ?? 0
            vc.delegate = self.vc as! WOWHotStyleDelegate?
            
            self.vc?.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
        
        
    }
    public func cyclePictureView(_ cyclePictureView: CyclePictureView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let model = bannerArray[(indexPath as NSIndexPath).row]
        let viewController = self.vc as! WOWBaseModuleVC
        viewController.goController(model)
    }
    
}
