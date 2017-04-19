//
//  WOWUpdateView.swift
//  AlterViewController
//
//  Created by 陈旭 on 2016/12/8.
//  Copyright © 2016年 陈旭. All rights reserved.
//

// 检查当前版本和appStore版本的差异

struct CheackAppVersion {
    
    static var cheackResult     : Int?// 比较的结果
    static var NewestVersion    : String?// 最新的版本号

    // 检查是否需要更新版本，以本地的bulding 参数做比较 
    static func compareVersion( currentVersion:String,appVersion:Int ){
        
        let currentSum = currentVersion.toInt() ?? 1000
        let appSum     = appVersion
        
        if currentSum == appSum {// 说明是最新版
            cheackResult = 0
        }else if currentSum < appSum { // 说明需要更新
            cheackResult = 1
        }else {// 说明当前的版本大于 AppStore 版本，  即，目前正在审核中
            cheackResult = 2
        }
        
    }
    
}

// APP更新的信息
class WOWUpdateVersionModel: WOWBaseModel,Mappable {

    var appSize                         :       String?
    var buildVersion                    :       String?
    var isRequiredUpgrade               :       Bool?
    var publishDateFormat               :       String?
    var publishLog                      :       String?
    var publishLogs                     :       [String]?
    var upgradeUrl                      :       String?
    var version                         :       String?
    var versionCode                     :       Int?// 本地的 buliding 的版本号。 和远程服务器接口返回的数据作比较。 如果本地的buliding 版本号大于 服务器的版本号，说明，此时正在审核。
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        appSize                             <- map["appSize"]
        buildVersion                        <- map["buildVersion"]
        isRequiredUpgrade                   <- map["isRequiredUpgrade"]
        publishDateFormat                   <- map["publishDateFormat"]
        publishLog                          <- map["publishLog"]
        publishLogs                         <- map["publishLogs"]
        upgradeUrl                          <- map["upgradeUrl"]
        version                             <- map["version"]
        versionCode                         <- map["versionCode"]

    }
    
}

import UIKit
import ObjectMapper
protocol UpdateHeightDelegate:class {
    
    func updateHeight(height:CGFloat)
    
    func actionBlcok()
    
}

class WOWUpdateView: UIView,UITableViewDelegate,UITableViewDataSource{
    
    var updateModel     : WOWUpdateVersionModel!{
        didSet{
            updateContent = updateModel.publishLogs ?? [""]
            updateHeaderView.lbVersion.text = updateModel.version
            updateHeaderView.lbAppSize.text = updateModel.appSize
            tableView.reloadData()
            
        }
    }
    var updateContent = [String]()
    
    @IBOutlet weak var tableView: UITableView!

    weak var delegate:UpdateHeightDelegate?
    
    @IBOutlet weak var heightAllLayout: NSLayoutConstraint!
    
    override func layoutSubviews() {
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
       heightAllLayout.constant = self.tableView.contentSize.height
        if let del = delegate {
            del.updateHeight(height: self.tableView.contentSize.height)
        }

    }
    override func awakeFromNib() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UpdateCell")
        self.tableView.rowHeight          = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let identify:String = "UpdateCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath) as UITableViewCell
        
        cell.textLabel?.text            = WOWTool.jointImgStr(imgArray: updateContent, spaceStr: "\n")
        cell.textLabel?.font            = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.numberOfLines   = 0
        cell.textLabel?.textColor       = UIColor.init(hexString: "808080")
        cell.selectionStyle             = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return updateHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return updateFooterView
    }
    
    lazy var updateHeaderView: WOWUpdateHeader = {
        let view = Bundle.loadResourceName(String(describing: WOWUpdateHeader.self)) as! WOWUpdateHeader

        return view
    }()
    lazy var updateFooterView: UIView = {
        let view = Bundle.loadResourceName(String(describing: WOWUpdateFooter.self)) as! WOWUpdateFooter
        
        view.updateBtn.addTarget(self, action: #selector(WOWUpdateView.clickAction), for: .touchUpInside)
        view.cancleBtn.addTarget(self, action:  #selector(WOWUpdateView.clickAction), for:.touchUpInside)
        return view
        
    }()
    func clickAction(_ sender:UIButton)  {
      
        switch sender.tag {
        case 0:
            // 后台 是否强制更新，  如果 为true  则强制用户更新版本 点击“取消”无反应。
            if updateModel.isRequiredUpgrade == false {
                
                if let del = delegate{
                    del.actionBlcok()
                }

            }else{
                WOWHud.showMsg("为了您更好的体验，请您更新版本")
            }
        case 1:
            print("点击更新")
            GoToItunesApp.show()
        default:break
        }
       
    }
    func updateAction()  {
        
    }

}
