//
//  WOWScreenView.swift
//  wowapp
//
//  Created by 陈旭 on 16/9/23.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit
class PriceSectionModel:NSObject {
    
    var maxPrice : Int?
    var minPrice : Int?
    
}
class SectionModel: NSObject {
    var sectionTitle : String?
    var isOut :Bool?
    
    init(sectionTitle : String ,isOut :Bool) {
        super.init()
        self.sectionTitle = sectionTitle
        self.isOut = isOut
    }
    
}
struct ScreenViewConfig{

    static var headerViewHight :CGFloat = 64
    static var footerViewHight :CGFloat = 50
    static var screenTitles             = ["颜色","价格范围","风格"]
    static let kDuration                = 0.3
    static let frameX :CGFloat          = 75.w
}
typealias SureScreenAction =  (_ ScreenConditions:AnyObject) -> ()
class WOWScreenView: UIView,CAAnimationDelegate {
    /* CellID */
    let cellColorID             = String(describing: SVColorCell.self)
    let cellPriceID             = String(describing: SVPriceCell.self)
    let cellStyleID             = String(describing: SVStyleCell.self)
    let cellCloosePriceID       = String(describing: SVCloosePriceCell.self)
    /* categoryId */
    let categoryId  :Int? = 10
    /* 数据源 */
    var mainModel               :ScreenConfigModel?
    var colorArr                = [ScreenModel]()
    var styleArr                = [ScreenModel]()
    var sceneArr                = [ScreenModel]()
    var priceArr                = [ScreenModel]()
    /* 配置信息 */
    var cellHightDic            = Dictionary<Int, CGFloat>()
    var arrayTitle              = [SectionModel]()
    /* 筛选条件 */
    var screenColorArr          = [String]()
    var screenStyleArr          = [String]()
    var screenPriceArr          =  Dictionary<String, Any>()
    var screenScreenArr         = [String]()
    
    var screenAction  : SureScreenAction!
    
    var cloosePriceModel  = PriceSectionModel()
    
    
    private var  btnBack :UIButton!
    private lazy var headerView: UIView = {
        
           let view                 = UIView()
           view.frame               = CGRect.init(x: 0, y: 0, width: self.w, height: ScreenViewConfig.headerViewHight)
           view.backgroundColor     = UIColor.white
           let lbTitle              = UILabel()
           lbTitle.frame            = CGRect.init(x: 0, y: 0, width: view.w, height: view.h)
           lbTitle.text             = "筛选条件"
           lbTitle.textAlignment    = .center
           lbTitle.font             = Fontlevel001
           lbTitle.textColor        = UIColor.black
           let lbBottom             = UILabel.initLable(" ", titleColor: UIColor.black, textAlignment: .center, font: 10)
           lbBottom.backgroundColor = UIColor.init(hexString: "eaeaea")
            view.addSubview(lbTitle)
            view.addSubview(lbBottom)
            lbBottom.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view)
                make.height.equalTo(0.5)
                make.left.equalTo(view)
                make.bottom.equalTo(view).offset(0)
            }

            return view
    
    }()
    private lazy var footerView: SVFooterView = {
        
      let view = Bundle.main.loadNibNamed(String(describing: SVFooterView.self), owner: self, options: nil)?.last as! SVFooterView
        
        
        return view
        
    }()
    private var backView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellHightDic = [0 : 40 ,
                        1 : 65 ,
                        2 : 44 ,
                        3 : 54 ]
        
        
        for a in 0..<ScreenViewConfig.screenTitles.count {
            let model = SectionModel.init(sectionTitle: ScreenViewConfig.screenTitles[a], isOut: false)
            arrayTitle.append(model)
        }
      

        configSubView()
        requstSceenData()
        
    }
    private func requstSceenData(){
        WOWNetManager.sharedManager.requestWithTarget(.Api_Screen_Main, successClosure: {[weak self] (result,code) in
            if let strongSelf = self{
                
                
                let json = JSON(result)
                DLog(json)

                strongSelf.mainModel = Mapper<ScreenConfigModel>().map(JSONObject:result)
                if let mainModel = strongSelf.mainModel{
                    
                    strongSelf.colorArr = []
                    strongSelf.colorArr = mainModel.colorList ?? []
                    strongSelf.styleArr = []
                    strongSelf.styleArr = mainModel.styleList ?? []
                    strongSelf.sceneArr = []
                    strongSelf.sceneArr = mainModel.sceneList ?? []
                    strongSelf.tableView.reloadData()
                    
                }
//                WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Screen_Price(categoryId: strongSelf.categoryId ?? 0), successClosure: { (result) in
//                
//                        let bannerList = Mapper<ScreenModel>().mapArray(JSONObject:JSON(result)["priceRanges"].arrayObject)
//                        if let bannerList = bannerList {
//                            
//                            strongSelf.priceArr = []
//                            strongSelf.priceArr = bannerList 
//                        }
//                    
//                }){ (errorMsg) in
//                    DLog(errorMsg)
//                }
            }
        }) { (errorMsg) in
           
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open lazy var tableView:UITableView = {
        
        let v = UITableView(frame: CGRect.init(x: 0, y: ScreenViewConfig.headerViewHight, width: self.w, height: self.h - ScreenViewConfig.headerViewHight - ScreenViewConfig.footerViewHight), style:.grouped)
//        v.separatorColor  = MGRgb(224, g: 224, b: 224)
        v.delegate        = self
        v.dataSource      = self
        v.separatorStyle  = .none
        v.backgroundColor = GrayColorLevel5
        return v
    }()

    private func configSubView(){

        self.addSubview(headerView)
        self.addSubview(footerView)
        footerView.snp.makeConstraints { [weak self](make) in
            make.bottom.left.width.equalTo(self!)
            make.height.equalTo(50)
        }
        footerView.btnClear.addTarget(self, action:#selector(clearAction), for:.touchUpInside)
        footerView.btnSure.addTarget(self, action:#selector(sureAction), for:.touchUpInside)
        tableView.register(UINib.nibName(cellColorID), forCellReuseIdentifier:cellColorID)
        tableView.register(UINib.nibName(cellCloosePriceID), forCellReuseIdentifier:cellCloosePriceID)
        tableView.register(UINib.nibName(cellStyleID), forCellReuseIdentifier:cellStyleID)
    
        self.addSubview(tableView)
        addObserver()
    }
    func showInView(view: UIView)  {
        
        btnBack = UIButton.init(type: UIButtonType.custom)
        btnBack.frame = CGRect(x: 0, y: 0,width: view.frame.size.width,height: view.frame.size.height)
        btnBack.backgroundColor = UIColor.black
        btnBack.alpha = 0.3
        btnBack.addTarget(self, action: #selector(WOWScreenView.hideView), for: .touchUpInside)
    
        view.addSubview(btnBack)
        let animation = CATransition.init()
        animation.delegate = self
        animation.duration = ScreenViewConfig.kDuration
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        self.layer.add(animation, forKey: "LocateViewRight")
        self.alpha = 1.0
        view.addSubview(self)
        
    }
    func hideView()  {
        
        let animation = CATransition.init()
        animation.delegate = self
        animation.duration = ScreenViewConfig.kDuration
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionPush;
        
        animation.subtype = kCATransitionFromLeft;
        self.alpha = 0.0
        self.layer.add(animation, forKey: "LocateViewLeft")
        self.perform(#selector(removeFromSuperview), with: nil, afterDelay: ScreenViewConfig.kDuration)
        btnBack.isHidden = true

    }
    func clearAction()  {
        print("clear")
        cloosePriceModel.minPrice = nil
        cloosePriceModel.maxPrice = nil
        screenColorArr.removeAll()
        screenStyleArr.removeAll()
        for model in colorArr {
            if model.isSelect {
                model.isSelect = false
            }
            
        }
        for model in styleArr {
            if model.isSelect {
                model.isSelect = false
            }
            
        }
        self.tableView.reloadData()
        let parms = [String: AnyObject]()
        screenAction(parms as AnyObject)
//        self.hideView()
    }
    func sureAction()  {
    
        if let min = cloosePriceModel.minPrice {
            
            screenPriceArr  = ["minPrice":min]
            
        }else {
            cloosePriceModel.minPrice = 0
        }
        if let max = cloosePriceModel.maxPrice {
            
            screenPriceArr  = ["minPrice":cloosePriceModel.minPrice ?? 0,"maxPrice":max]
        }else{
            screenPriceArr  = ["minPrice":cloosePriceModel.minPrice ?? 0]
        }
        if let min = cloosePriceModel.minPrice ,let max = cloosePriceModel.maxPrice {
            if min > max {
                
              screenPriceArr  = ["minPrice":max,"maxPrice":min]
            cloosePriceModel.maxPrice = min
            cloosePriceModel.minPrice = max
            self.tableView.reloadData()
//            WOWHud.showMsg("请输入正确的价格范围")
//                return
            }
        }
        var parms = [String: AnyObject]()
        parms = ["colorList" :screenColorArr as AnyObject,
                 "priceObj"  :screenPriceArr as AnyObject,
                 "styleList" :screenStyleArr as AnyObject,
                 "sceneList" :screenScreenArr as AnyObject
        ]
//        SureScreenAction(parms)
        screenAction(parms as AnyObject)
        self.hideView()
    }

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    private func addObserver(){
        /**
         添加通知
         */

        NotificationCenter.default.addObserver(self, selector:#selector(getScreenConditions), name:NSNotification.Name(rawValue: WOWUpdateScreenConditionsKey), object:nil)
        
    }
    func  getScreenConditions (sender: NSNotification){
//        print(sender.object)
        guard (sender.object != nil) else{//
                return
        }
       
        if  let dic =  sender.object as? [String:AnyObject] {
            
            if dic["colorIdArr"] != nil {
                screenColorArr  = dic["colorIdArr"] as! [String]
            }
            if dic["priceArr"] != nil {
                screenPriceArr  = dic["priceArr"] as! Dictionary
            }
            
            if dic["styleIdArr"] != nil {
                screenStyleArr  = dic["styleIdArr"] as! [String]
            }
            
            if dic["screenIdArr"] != nil {
                screenScreenArr  = dic["screenIdArr"] as! [String]
            }
            
        }

    }

}
extension WOWScreenView:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let model = arrayTitle[section]
        guard model.isOut == true else {
            return 0
        }
        switch section {
        case 2:
            return styleArr.count
        case 0:
            
            return colorArr.count > 0 ? 1 : 0
        
        case 1:
            
//            return priceArr.count > 0 ? 1 : 0
            return 1
            

        case 3:
            return sceneArr.count
        default:
            return 0
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
            return self.cellHightDic[indexPath.section] ?? 0

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell            = tableView.dequeueReusableCell(withIdentifier: cellColorID, for: indexPath as IndexPath) as! SVColorCell
            cell.delegate     = self
            cell.indexPathNow = indexPath as NSIndexPath!
            cell.dataArr        = colorArr
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell            = tableView.dequeueReusableCell(withIdentifier: cellCloosePriceID, for: indexPath as IndexPath) as! SVCloosePriceCell
            
//            cell.delegate     = self
//            cell.indexPathNow = indexPath as NSIndexPath!
//            cell.dataArr      = priceArr
            cell.modelPrice     = self.cloosePriceModel
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell                = tableView.dequeueReusableCell(withIdentifier: cellStyleID, for: indexPath as IndexPath) as! SVStyleCell
            let model = styleArr[indexPath.row]
            cell.showData(m: model)
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell                = tableView.dequeueReusableCell(withIdentifier: cellStyleID, for: indexPath as IndexPath) as! SVStyleCell
            
            let model = sceneArr[indexPath.row]
   
            cell.showData(m: model)
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            
            var params : [String: AnyObject]
             params = styleArr.getScreenCofig(index: indexPath.row,dicKey: "styleIdArr")
             NotificationCenter.postNotificationNameOnMainThread(WOWUpdateScreenConditionsKey, object: params as AnyObject?)
            tableView.reloadData()
            
        case 3:
             var params : [String: AnyObject]
            params = sceneArr.getScreenCofig(index: indexPath.row,dicKey: "screenIdArr")
            NotificationCenter.postNotificationNameOnMainThread(WOWUpdateScreenConditionsKey, object: params as AnyObject?)
            tableView.reloadData()
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = arrayTitle[section]
        return headerView(title: model.sectionTitle ?? "", isOut: model.isOut ?? false,indexSection: section)
    }
    func headerView(title: String, isOut: Bool,indexSection:Int) -> UIView {
        let v        = UIView()
        v.frame      = CGRect(x: 0,y: 0,width: self.w,height: 70)
        v.backgroundColor = UIColor.white
        let lbTitle  = UILabel()
        lbTitle.text = title
        lbTitle.font = Fontlevel002
        
        let model = self.arrayTitle[indexSection]
        
        let imgOut   = UILabel()
        imgOut.font  = UIFont.systemFont(ofSize: 20)

        if (model.isOut ?? false) {
            imgOut.text   = "-"
        }else{
            imgOut.text   = "+"
        }
        imgOut.textAlignment = .center

        v.addTapGesture(action: {[weak self] (tap) in
            if let strongSelf = self{
               let modelA = strongSelf.arrayTitle[indexSection]
                
                if (modelA.isOut ?? false) {
                    
                    modelA.isOut = false
                  
                }else{
                 
                    modelA.isOut = true
                }

               strongSelf.tableView.reloadSections([indexSection], animationStyle: .automatic)

            }
        })

        let lbBottom             = UILabel.initLable(" ", titleColor: UIColor.black, textAlignment: .center, font: 10)
        lbBottom.backgroundColor = UIColor.init(hexString: "eaeaea")
    
        v.addSubview(lbTitle)
        v.addSubview(imgOut)
        v.addSubview(lbBottom)
        lbTitle.snp.makeConstraints { (make) in
            make.bottom.top.right.equalTo(v)
            make.left.equalTo(v).offset(20)
        }
        imgOut.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.centerYWithinMargins.equalTo(v)
            make.right.equalTo(v).offset(-10)
        }
        lbBottom.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(v)
            make.height.equalTo(0.5)
            make.left.equalTo(v).offset(15)
            make.bottom.equalTo(v).offset(0)
        }

        return v
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
extension WOWScreenView:SVColorCellDelegate,SVPriceCellDelegate{
    func updataTableViewCellHight(cell: SVColorCell,hight: CGFloat,indexPath: NSIndexPath){

        guard self.cellHightDic[indexPath.section] == hight else{
            self.cellHightDic[indexPath.section] = hight
            tableView.reloadData()
            return
        }
    }
    func updataTableViewCellHightFormPrice(cell: SVPriceCell,hight: CGFloat,indexPath: NSIndexPath){
        guard self.cellHightDic[indexPath.section] == hight else{
            self.cellHightDic[indexPath.section] = hight
            tableView.reloadData()
            return
        }

    }
}
