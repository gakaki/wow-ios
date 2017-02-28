//
//  WOWMessageViewController.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWMessageController: WOWBaseViewController {
    @IBOutlet var tableView: UITableView!
    
    var messageArr: [WOWMessageModel]?
    
    let cellID = String(describing: WOWMessageCenterCell.self)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        requestMsgCount()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        removeObservers()
    }
    fileprivate func addObserver(){
        
        NotificationCenter.default.addObserver(self, selector:#selector(updateMsgCount), name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object:nil)
        
    }
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: WOWUpdateCarBadgeNotificationKey), object: nil)
    }
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        //隐藏消息按钮
        rightNagationItem.infoButton.isHidden = true
        rightNagationItem.newView.isHidden = true
        addObserver()
        
        tableView.mj_header = self.mj_header
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = GrayColorLevel5
        tableView.separatorColor = SeprateColor
        tableView.estimatedRowHeight = 130
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier: cellID)

    }
    override func request() {
        super.request()
        
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageMain, successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let r                                     =  JSON(result)
                let arr = Mapper<WOWMessageModel>().mapArray(JSONObject:r["messageLists"].arrayObject)
                strongSelf.messageArr = arr
                strongSelf.configData()
                strongSelf.endRefresh()
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
    func requestMsgCount() {
        
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageCount, successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                let json = JSON(result)
                let systemMsg = json["systemMessageUnReadCount"].int
                let userMsg = json["userMessageUnReadCount"].int
                WOWUserManager.systemMsgCount = systemMsg ?? 0
                WOWUserManager.userMsgCount = userMsg ?? 0
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                
                DLog(json)
                
            }
        }) { (errorMsg) in
          
            
        }
        
    }
    
    func requestMsgRead(messageId: Int, msgType: Int) {
        //单个消息已读
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageRead(messageId: messageId, msgType: msgType), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                    ///1为系统消息；2为官方消息
                if msgType == 1 {
                    let count = WOWUserManager.userMsgCount - 1
                    WOWUserManager.userMsgCount = count < 0 ? 0 : count
                }else{
                    let count = WOWUserManager.systemMsgCount - 1
                    WOWUserManager.systemMsgCount = count < 0 ? 0 : count
                }
                //每次标记已读消息都要发一个通知，刷新前面的信封
                NotificationCenter.postNotificationNameOnMainThread(WOWUpdateCarBadgeNotificationKey, object: nil)
                strongSelf.request()
                
            }
        }) {(errorMsg) in
            
        }
    }

    func configData() {
        
        tableView.reloadData()
    }
    func updateMsgCount() {
        request()
    }

}
extension WOWMessageController:UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMessageCenterCell
        if let array = messageArr {
            cell.showData(model: array[indexPath.row])
            cell.delegate = self
            //如果是最后一行的话隐藏横线
            if array.count > 0 {
                if indexPath.row == array.count - 1 {
                    cell.lineView.isHidden = true
                }else {
                    cell.lineView.isHidden = false
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转消息中心
            let vc = UIStoryboard.initialViewController("Message", identifier:String(describing: WOWMessageInfoController.self)) as! WOWMessageInfoController
            vc.hideNavigationBar = false
            vc.msgType = messageArr?[indexPath.row].msgType
            pushVC(vc)
    }
    
    //MARK: - EmptyData
    func imageForEmptyDataSet(_ scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "no_message_icon")
    }
    
    override func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "还没有消息"
        let attri = NSAttributedString(string: text, attributes:[NSForegroundColorAttributeName:MGRgb(74, g: 74, b: 74),NSFontAttributeName:UIFont.systemScaleFontSize(14)])
        return attri
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    
}

extension WOWMessageController: WOWMessageInfoCellDelegate {
    func goMsgDetail(model: WOWMessageModel) {
        
        if let messageId = model.messageId, let isRread = model.isRead, let msgType = model.msgType {
            //只有在未读的时候才去请求接口
            if !isRread {
                requestMsgRead(messageId: messageId, msgType: msgType)
            }
        }
        if let openType = model.openType {
            if openType == 2 {
                
                WOWMessageToVc.goVc(type: model.targetType, id: model.targetId)
                
            }
        }
    }
}
