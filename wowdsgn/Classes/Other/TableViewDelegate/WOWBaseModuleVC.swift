//
//  WOWBaseRouteVC.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/10.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWBaseModuleVC: WOWBaseViewController {
    

    var myQueueTimer1: DispatchQueue?
    var myTimer1: DispatchSourceTimer?
    override func viewDidLoad() {
        super.viewDidLoad()

 
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func timerCount(array: Array<WOWHomeModle>){
        myQueueTimer1 = DispatchQueue(label: "myQueueTimer")
        myTimer1 = DispatchSource.makeTimerSource(flags: [], queue: myQueueTimer1!)
        myTimer1?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(10))
        myTimer1?.setEventHandler {
            for model in array {
                if model.moduleType == 801 {
                    for product in  (model.moduleContentProduct?.products) ?? [] {
                        if product.timeoutSeconds > 0{
                            product.timeoutSeconds  = product.timeoutSeconds - 1
                        }
                    }
                }
            }
        }
        myTimer1?.resume()
        
    }

    func data(result: AnyObject) -> Array<WOWHomeModle> {
        
        var dataArr = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
        
        if let brandArray = dataArr{
            
            var singProductArray = [WOWHomeModle]() // 今日单品 倒计时的产品 数组

            for t in brandArray{
                switch t.moduleType ?? 0 {
                case 302:
                    if let s  = t.moduleContentTmp!["categories"] as? [AnyObject] {
                        t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                    }
                case 401:
                    if let s  = t.moduleContentTmp!["products"] as? [AnyObject] {
                        t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                        t.name = (t.moduleContentTmp!["name"] as? String) ?? "本周上新"
                        
                    }
                    
                case 201:
                    if let s  = t.moduleContentTmp  {
                         t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                    }
                case 501:
                    if let s  = t.moduleContentTmp  {
                         t.moduleContentItem   =  Mapper<WowModulePageItemVO>().map(JSONObject:s)
                    }
                case 301:
                    if let s  = t.moduleContentTmp!["categories"] as? [AnyObject] {
                         t.moduleContentArr    =  Mapper<WowModulePageItemVO>().mapArray(JSONObject:s) ?? [WowModulePageItemVO]()
                    }
                    
                case 801:
                     singProductArray.append(t)
                case 701,601,101,102,402,901,1001,103:
                    print("")
                default:
                    // 移除 cell for row 里面不存在的cellType类型，防止新版本增加新类型时，出现布局错误
                    dataArr?.removeObject(t)
                }
                
            }
            // 拿到数据，倒计时刷新数据源model
            if singProductArray.count > 0 {
                
                self.timerCount(array: singProductArray)
            }
            
        }
        return dataArr ?? []
    }
    
//    //点击跳转
    func goController(_ model: WOWCarouselBanners) {
        if let bannerLinkType = model.bannerLinkType {
            switch bannerLinkType {
            case 1:
                let vc = WOWWebViewController()
                if let url = model.bannerLinkUrl{
                    vc.url = url
                }
                
                navigationController?.pushViewController(vc, animated: true)
                print("web后台填连接")
            case 2:
                print("专题详情页（商品列表）")
            case 3:
                print("专题详情页（图文混排）")
            case 4:
                print("品牌详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                vc.brandID = model.bannerLinkTargetId
                vc.entrance = .brandEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
                
            case 5:
                print("设计师详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWBrandHomeController.self)) as! WOWBrandHomeController
                vc.designerId = model.bannerLinkTargetId
                vc.entrance = .designerEntrance
                vc.hideNavigationBar = true
                navigationController?.pushViewController(vc, animated: true)
            case 6:
                print("商品详情页")
                let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController.self)) as! WOWProductDetailController
                vc.hideNavigationBar = true
                vc.productId = model.bannerLinkTargetId
                navigationController?.pushViewController(vc, animated: true)
                
            case 7:
                print("分类详情页")
                
            case 8:// 专题详情
                toVCTopic(model.bannerLinkTargetId ?? 0)
                print("场景还是专题")
            case 9:// 专题详情
                
                toVCTopidDetail(model.bannerLinkTargetId ?? 0)
                
            default:
                print("其他")
            }
            
        }
        
    }

}
extension WOWBaseModuleVC:HomeBottomDelegate{
    
    func goToProductDetailVC(_ productId: Int?) {//跳转产品详情
        
        toVCProduct(productId)
        
    }
    
}
extension WOWBaseModuleVC:WOWHomeFormDelegate{
    
    func goToVC(_ m:WOWModelVoTopic){//右滑更多 跳转专题详情
        if let cid = m.id{
            
            toVCTopic(cid)
            
        }
    }
    func goToProdectDetailVC(_ productId: Int?) {// 跳转产品详情页
        
        toVCProduct(productId)
        
    }
}

extension WOWBaseModuleVC:SenceCellDelegate{
    func senceProductClick(_ produtID: Int) {//根据ID跳转产品详情页
        toVCProduct(produtID)
    }
}
extension WOWBaseModuleVC:cell_102_delegate{
    func goToProjectDetailVC(_ model: WOWCarouselBanners?){
        if let model = model {
            goController(model)
        }
        
    }
}
extension WOWBaseModuleVC:cell_801_delegate{// 今日单品跳转详情
    func goToProcutDetailVCWith_801(_ productId: Int?){
        toVCProduct(productId)
    }
}
extension WOWBaseModuleVC:WOWHotStyleCellDelegate{
    
    func reloadTableViewDataWithCell(){
        
        request()
        
    }
    
}
extension WOWBaseModuleVC:WOWHotStyleDelegate{
    
    func reloadTableViewData(){
        
        request()
        
    }
    
}
//func notLoginThanToLogin(){
//    if  (!WOWUserManager.loginStatus){
//        toLoginVC(true)
//    }
//}
extension WOWBaseModuleVC:FoundWeeklyNewCellDelegate{
    
    func cellFoundWeeklyNewCellTouchInside(_ m:WowModulePageItemVO){

        
        if let pid = m.productId as Int? {
            self.toVCProduct(pid)
        }
    }
    
}
extension WOWBaseModuleVC:MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate{
    
    func MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate_CellTouchInside(_ m:WowModulePageItemVO?)
    {
        if let cid = m!.categoryId , let cname = m!.categoryName{
            toVCCategory( cid ,cname: cname)
        }
    }
    
}

extension WOWBaseModuleVC:Cell_501_Delegate{
    
    func toProductDetail(_ productId: Int?) {
        toVCProduct(productId)
    }
    
}
extension WOWBaseModuleVC:Cell_302_Delegate{
    
    func MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(_ m:WowModulePageItemVO?)
    {
        
        if m == nil {
            toVCCategoryChoose()
        }else{
            if let cid = m!.categoryId , let cname = m!.categoryName{
                toVCCategory( cid,cname: cname)
            }
        }
        
    }

    
}
extension WOWBaseModuleVC:WOWHotColumnDelegate{
    func goToArticleListVC(_ columntId: Int?) {
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWHotArticleList.self)) as! WOWHotArticleList
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
