//
//  WOWMessageInfoController.swift
//  wowdsgn
//
//  Created by 安永超 on 16/12/8.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWMessageInfoController: WOWBaseViewController {
    @IBOutlet var tableView: UITableView!
    
    var msgArr = [WOWMessageModel]()
    let pageSize        = 10
    var msgType: Int?
    
    let cellID = String(describing: WOWMessageInfoCell.self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        if msgType == 1 {
            self.title = "系统消息"
        }else{
            self.title = "官方消息"
        }
        makeCustomerNavigationItem("全部已读", left: false){[weak self] () -> () in
            if let strongSelf = self{
                strongSelf.requestMsgAllRead()
            }
            
        }
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = GrayColorLevel5
        tableView.separatorColor = SeprateColor
        tableView.estimatedRowHeight = 130
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier: cellID)
        
    }
    
    //MARK: 网络请求
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageList(msgType: msgType ?? 0, pageSize: pageSize, currentPage: pageIndex), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWMessageModel>().mapArray(JSONObject:JSON(result)["messageLists"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.msgArr = []
                    }
                    strongSelf.msgArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.msgArr = []
                    }
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.tableView.reloadData()

            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
        
        
        
       

    }
    
    func requestMsgRead(messageId: Int) {
        //单个消息已读
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageRead(messageId: messageId, msgType: msgType ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                
                strongSelf.tableView.reloadData()
                
            }
        }) {(errorMsg) in
            
        }
    }
    
    func requestMsgAllRead() {
        //全部读取
        WOWNetManager.sharedManager.requestWithTarget(.api_MessageAllRead(msgType: msgType ?? 0), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                
                strongSelf.tableView.reloadData()
                
            }
        }) {(errorMsg) in
            
        }
    }
    
}
extension WOWMessageInfoController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMessageInfoCell
        cell.showData(model: msgArr[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
}

extension WOWMessageInfoController: WOWMessageInfoCellDelegate {
    func goMsgDetail(model: WOWMessageModel) {
        
        if let messageId = model.messageId {
            
            requestMsgRead(messageId: messageId)

        }
    }
}

