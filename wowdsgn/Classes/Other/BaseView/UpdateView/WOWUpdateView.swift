//
//  WOWUpdateView.swift
//  AlterViewController
//
//  Created by 陈旭 on 2016/12/8.
//  Copyright © 2016年 陈旭. All rights reserved.
//
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
