//
//  WOWTableDelegate.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/9.
//  Copyright © 2016年 g. All rights reserved.
//
enum ControllerViewType { // 区分底部列表
    case Home        // 首页
    case Buy            // 分类页
    case HotStyle     // 精选页
}
import UIKit
import UITableView_FDTemplateLayoutCell
class WOWTableDelegate: NSObject,UITableViewDelegate,UITableViewDataSource,CyclePictureViewDelegate {
    open var vc : UIViewController?
    open var ViewControllerType  :ControllerViewType?
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮
    var lastContentOffset :CGFloat = 0.0

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
            

            self.tableView.register(UINib.nibName("Cell_105_Item"), forCellReuseIdentifier: "Cell_105_Item")
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
                    DLog("\(k) = \(c)")
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
            
            bottomListArray.ergodicArrayWithProductModel(dic: send_obj, successLikeClosure:{[weak self] in // 底部瀑布流取消掉，
                if let strongSelf = self {
                    strongSelf.tableView.reloadData()
                }
                
            })

    
            for j in record_402_index { // 遍历自定义产品列表，确保刷新喜欢状态
                let model = dataSourceArray[j]
                model.moduleContentProduct?.products?.ergodicArrayWithProductModel(dic: send_obj, successLikeClosure:{[weak self] in
                            if let strongSelf = self {
                                    strongSelf.tableView.reloadData()

                            }
                    
                })

            }
 
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < dataSourceArray.count {
            let model = dataSourceArray[section]
            
            
            switch model.moduleType ?? 0 {
            case 402:// 多行展示
                record_402_index.removeObject(section)
                record_402_index.append(section)
                
                let array = model.moduleContentProduct?.products ?? []
                return (array.count.getParityCellNumber()) > 3 ? 3: (array.count.getParityCellNumber())
            
            case 105:
                guard model.moduleContent?.bannerIsOut == true else {// 返回 0
                    
                    return 1
                }
                
                return (model.moduleContent?.banners?.count ?? 1) + 1
                
                
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
                cell.pageTitle = vc?.title ?? ""
                
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
            if let moduleContent = model.moduleContent {
                cell.showData(moduleContent)
                cell.model = moduleContent
                cell_heights[section]  = cell.heightAll
            }
            
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
                cell.delegate = self.vc as! HomeBrannerDelegate?
                cell.moduleId = model.moduleId
                cell.pageTitle = vc?.title
            }
            cell.indexPathSection = indexPath.section
            cell_heights[section]  = cell.heightAll
            returnCell = cell
            
        case 102:
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell_102_Project
            if (model.moduleContent?.link) != nil {
                cell.itemBottomHeight = 0.0
            }else {
                cell.itemBottomHeight = 10.0
            }
            cell.dataArr      = model.moduleContent?.banners
//            cell.lbTitle.text = model.moduleContent?.name ?? "专题"
            cell.pageTitle = vc?.title ?? ""
            cell.moduleId = model.moduleId ?? 0
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
            
            cell.pageTitle = vc?.title ?? ""
            cell.moduleId = model.moduleId ?? 0
            cell.moduleType = 402
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
//            cell.setData(model.moduleContentArr)
            if let dataArr = model.moduleContentProduct?.products {
                cell.data  = dataArr
            }
            
            cell_heights[section]  = cell.heightAll
            cell.delegate = self.vc as! FoundWeeklyNewCellDelegate?
            cell.pageTitle = vc?.title ?? ""
            cell.moduleId = model.moduleId ?? 0
            cell.bringSubview(toFront: cell.cv)
            
            returnCell = cell
            
            
        case Cell_501_Recommend.cell_type():
            
            let cell = tableView.dequeueReusableCell( withIdentifier: identifier , for: indexPath) as! Cell_501_Recommend
            cell.delegate       = self.vc as! Cell_501_Delegate?
            if let moduleContentItem = model.moduleContentItem {
                cell.showData(moduleContentItem)

            }
            
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
            cell.dataArr = model.moduleContent?.banners ?? [WOWCarouselBanners]()

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
                cell.moduleId = model.moduleId ?? 0
                cell.pageTitle = vc?.title ?? ""
                cell.reloadBanner(banners)
                cell.delegate = self.vc as! HotBrannerCellDelegate?

            }

            returnCell = cell
        case 107:
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell_107_BrandZone
            if (model.moduleContent?.link) != nil {
                cell.itemBottomHeight = 0.0
            }else {
                cell.itemBottomHeight = 10.0
            }
            cell.delegate = self.vc as! Cell_107_BrandZoneDelegate?
            cell.moduleId = model.moduleId ?? 0
            cell.pageTitle = vc?.title ?? ""
            cell.modelData = model.moduleContent
            returnCell = cell
        case 106:
            let cell                = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell_106_BrandList
            
            if (model.moduleContent?.link) != nil {
                cell.itemBottomHeight = 0.0
            }else {
                cell.itemBottomHeight = 10.0
            }

            if let banners = model.moduleContent?.banners{
                cell.dataArr = banners
                cell.pageTitle = vc?.title ?? ""
                cell.moduleId = model.moduleId ?? 0
            }
            cell.delegate = self.vc as! Cell_106_BrandListDelegate?
            
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
                     return 10
                }
               
            }
        let model = dataSourceArray[section]
        let bottom = CGFloat(model.moduleStyle?.marginBottom ?? 10)
        switch model.moduleType ?? 0{
        case 901,1001,103:// 精选页这几个Cell UI上没有 15px
            switch ViewControllerType ?? .Home{
            case .HotStyle:
                return bottom
            default:
                return bottom
            }
        case 102,107,106:
            if (model.moduleContent?.link) != nil {
                return 50 + bottom
            }else {
                return bottom
            }
        case 105:
            return CGFloat.leastNormalMagnitude
        case 402,401:
            
            return 50 + bottom
            
        default:
             return bottom
        }
        


    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

            guard section < dataSourceArray.count  else {// 说明是底部列表 section
                
                if section == ((dataSourceArray.count ) + bottomCellLine) - 1{
                    if isOverBottomData == true {
                        return footerView()
                    }
                }
                return nil
            }
        
            let model = dataSourceArray[section]
            let bottom = CGFloat(model.moduleStyle?.marginBottom ?? 10)
            switch model.moduleType ?? 0{// 不同的type  不同的页脚
                    case 102,107,106:
                        if let link = model.moduleContent?.link {
                            return hearderBaseBottomView(bannerModel: link, module: model,bottomHeight: bottom)
                        }else {
                            return nil
                        }

                    case 402,401:
                       
                        return hearderBaseBottomView(bannerModel: nil, is402: true, id: model.moduleContentProduct?.id ?? 0, module: model,bottomHeight: bottom)
                    
                default:
                    return nil
                }


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
                case 301,501,104:
                    
                    return 50
                case 102,402,107,106,401:
                    return 70
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
                case 102,107,106,401:
                    isHiddenLien = true
                    t            = model.moduleName ?? "专题"
                    return hearderBaseTopView(title: t, subTitle: model.moduleDescription ?? "", isHiddenLine: true)
                case 402:
                    isHiddenLien = false
                    t            =  model.moduleName ?? "居家好物"
                    return hearderBaseTopView(title: t, subTitle: model.moduleDescription ?? "")
                case 501:
                    isHiddenLien = true
                    t            = "单品推荐"
                case 301:
                    isHiddenLien = true
                    t            = model.name ?? "场景"
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
    // 控制展示  滑到顶部的按钮
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let wowcontroller  = self.vc as? WOWBaseModuleVC
            if scrollView.mj_offsetY < wowcontroller?.backTopBtnScrollViewOffsetY {
                wowcontroller?.topBtn.isHidden = true
            }else{
                wowcontroller?.topBtn.isHidden = false
        }
 
        switch ViewControllerType ?? .Home {
        case .Home:
            let a = scrollView.contentOffset.y
            
            if a -  lastContentOffset  > 20 && a > 0{
                
                lastContentOffset = a
                self.vc?.navigationController?.setNavigationBarHidden(true, animated: true)

                break
            }else if lastContentOffset - a > 20 && (a  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) {
                lastContentOffset = a
                
                self.vc?.navigationController?.setNavigationBarHidden(false, animated: true)
                    
                
                break
            }
            break
        default:
            break
        }


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
        view.btnMore.isHidden = true
        return view
        
    }
    
    //  2.0 版本 居中页眉
    func hearderBaseTopView(title: String,subTitle: String,isHiddenLine:Bool = false) -> UIView { // 137 37
        
        let view = Bundle.main.loadNibNamed("WOWHomeBaseTopView", owner: self, options: nil)?.last as! WOWHomeBaseTopView
            view.lbTitle.text       = title
        if isHiddenLine{
            view.lbLine.isHidden    = true
        }else{
            view.lbLine.isHidden    = false
        }
            view.lbSubTitle.text    = subTitle
        
        return view
        
    }
    // 2.0 版本 查看更多页脚
    func hearderBaseBottomView(bannerModel: WOWCarouselBanners?,is402:Bool = false,id:Int = 0, module: WOWHomeModle,bottomHeight:CGFloat = 10) -> UIView { // 137 37
        
        let view = Bundle.main.loadNibNamed("WOWHomeBaseBottomView", owner: self, options: nil)?.last as! WOWHomeBaseBottomView
        view.imgBackgroud.addTapGesture {[weak self] (sender) in
            if let strongSelf = self {
                switch module.moduleType ?? 0{// 不同的type  不同的页脚
                case 102:
                    //Mob 纵向banner模块 更多点击
                    let allType = String(format: "%i_%@_%i", module.moduleId ?? 0, strongSelf.vc?.title ?? "", bannerModel?.bannerLinkType ?? 0)
                    let params = ["ModuleID_Secondary_Homepagename_Viewalltragettype": allType]
                    MobClick.e2(.Bannerlist_Portrait, params)
                    
                    break
                case 106:
                    //Mob 热门分类模块 更多点击
                    let allType = String(format: "%i_%@_%i", module.moduleId ?? 0, strongSelf.vc?.title ?? "", bannerModel?.bannerLinkType ?? 0)
                    let params = ["ModuleID_Secondary_Homepagename_Viewalltragettype": allType]
                    MobClick.e2(.Hot_Category_Clicks, params)
                    
                    break
                case 107:
                    //Mob 品牌专区模块 更多点击
                    let allType = String(format: "%i_%@_%i", module.moduleId ?? 0, strongSelf.vc?.title ?? "", bannerModel?.bannerLinkType ?? 0)
                    let params = ["ModuleID_Secondary_Homepagename_Viewalltragettype": allType]
                    MobClick.e2(.Brand_Module_Clicks, params)

                    break
                case 401:
                    //Mob 横向产品组模块 更多点击
                    let allType = String(format: "%i_%@_%i", module.moduleId ?? 0, strongSelf.vc?.title ?? "", id)
                    let params = ["Mod uleID_Secondary_Homepagename_Viewalltragettype": allType]
                    MobClick.e2(.Productlist_Landscape, params)
                    break
                
                case 402:
                    //Mob 纵向产品组模块 更多点击
                    let allType = String(format: "%i_%@_%i", module.moduleId ?? 0, strongSelf.vc?.title ?? "", id)
                    let params = ["Mod uleID_Secondary_Homepagename_Viewalltragettype": allType]
                    MobClick.e2(.Productlist_Portrait, params)
                    break
        
                default:
                    break
                }

                if is402 {
                    DLog("跳转对应的产品组的详情页\(id)")
                    
                    VCRedirect.goToProductGroup(id)
                    
                }else{
                    let v = strongSelf.vc as? WOWBaseModuleVC
                    if let bannerModel = bannerModel {
                        v?.goController(bannerModel)

                    }
                }
               
            }
            
        }

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
            v.btnMore.addAction {// 点击更多跳转对应的产品组详情页
                DLog("跳转对应的产品组的详情页\(id)")
                VCRedirect.goToProductGroup(id)

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
            default: // 底部列表点击事件
                
                let model = bottomHotListArray[indexPath.section - dataSourceArray.count]
                
                let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
                //                vc.hideNavigationBar = true
                vc.topic_id = model.id ?? 0
                
                vc.modelStyleData = model
                
                self.vc?.navigationController?.pushViewController(vc, animated: true)
                
            }
            return
        }
        let model = dataSourceArray[(indexPath as NSIndexPath).section]
        switch model.moduleType ?? 0{// 不同type 跳转不同的类型
        case 201://单个图片
            if let modelBanner = model.moduleContent {
                //Mob 单张banner模块
                let bannerId = String(format: "%i_%@_%i", model.moduleId ?? 0, vc?.title ?? "", modelBanner.id ?? 0)
                let bannerName = String(format: "%i_%@_%@", model.moduleId ?? 0, vc?.title ?? "", modelBanner.bannerTitle ?? "")
                let params = ["ModuleID_Secondary_Homepagename_Bannerid": bannerId, "ModuleID_Secondary_Homepagename_Bannername": bannerName]
                MobClick.e2(.Single_Banner_Clicks, params)
                
                let v = self.vc as? WOWBaseModuleVC
                
                v?.goController(modelBanner)
                
            }
        case 701:// 精选页点赞cell
            let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController
            //                vc.hideNavigationBar = true
            vc.topic_id = model.moduleContentList?.id ?? 0
            vc.delegate = self.vc as! WOWHotStyleDelegate?
            
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        case 105:
            
            if let banners = model.moduleContent?.banners {
                if indexPath.row > 0 {
                    let v = self.vc as? WOWBaseModuleVC
                    v?.goController(banners[indexPath.row - 1])
                }
            }

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

