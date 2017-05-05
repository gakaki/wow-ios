//
//  WOWWorksActivityController.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/2.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorksActivityController: WOWBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var publishBtn: UIButton!
    
    let titleCellID = "WOWWorksTitleCell"
    var topicId: Int = 1
    var fineWroksArr = [WOWWorksListModel]()
    var topicModel: WOWActivityModel?
    let pageSize   = 10
    var cellHeight: CGFloat = 0
    var titleHeight: CGFloat = 0
    var line = 0
    var sortType: Int = 0
    var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 9) / 2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        // Do any additional setup after loading the view.
    }
    
    override func setUI() {
        super.setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.mj_header = mj_header
        tableView.mj_footer = mj_footer
        tableView.clearRestCell()
        tableView.register(UINib.nibName(titleCellID), forCellReuseIdentifier:titleCellID)
        self.navigationController?.makeCustomerImageNavigationItem("share-black", left: false, handler: {
            let shareUrl = WOWShareUrl + "/topic/\(topic_id )"
            WOWShareManager.share(vo_topic?.topicName, shareText: vo_topic?.topicDesc, url:shareUrl,shareImage:vo_topic?.topicImg ?? UIImage(named: "me_logo")!)
        })

    }

    @IBAction func publishAction(sender: UIButton) {
        
    }
    //MARK: -- NET
    override func request() {
        super.request()
        
        if pageIndex == 1 {
            requestTitle()
        }else {
            requestList()
        }
        
    }

    func requestList()  {
        
        var params = [String: Any]()
        params = ["categoryId": topicModel?.instagramCategoryId ?? 0 ,"startRows":(pageIndex-1) * 10,"pageSize":pageSize, "sortType": sortType]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_InstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWWorksListModel>().mapArray(JSONObject:JSON(result).arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.fineWroksArr = []
                    }
                    strongSelf.fineWroksArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.fineWroksArr = []
                    }
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
                let rows: Int = Int(strongSelf.fineWroksArr.count/2) + strongSelf.fineWroksArr.count%2
                strongSelf.cellHeight = strongSelf.titleHeight + CGFloat(rows) * (strongSelf.itemWidth + 3) + 100
                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
                if strongSelf.pageIndex > 1 {
                    strongSelf.pageIndex -= 1
                }
            }
        }
    }
    func requestTitle() {
        WOWNetManager.sharedManager.requestWithTarget(.api_Works_Topic(topicId: topicId), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                let r                             =  JSON(result)
                strongSelf.topicModel          =  Mapper<WOWActivityModel>().map(JSONObject: r.object )
                //计算label高度
                //标题高度
                let titleH = strongSelf.topicModel?.title?.heightWithConstrainedWidth(MGScreenWidth - 30, font: UIFont.mediumScaleFontSize(20), lineSpace: 1) ?? 0
                //内容高度
                var contentH = strongSelf.topicModel?.title?.heightWithConstrainedWidth(MGScreenWidth - 30, font: UIFont.systemFont(ofSize: 15), lineSpace: 1) ?? 0
                //单行高度
                let lineH = (strongSelf.topicModel?.content?.size(UIFont.systemFont(ofSize: 15)).height ?? 1) + 1
                //计算一共多少行
                strongSelf.line = Int(contentH/lineH)
                if strongSelf.line > 4 {
                    contentH = 4 * lineH
                    strongSelf.titleHeight = titleH + contentH + 94 + (strongSelf.topicModel?.picHeight ?? 0)
                }else {
                    strongSelf.titleHeight = titleH + contentH + 55 + (strongSelf.topicModel?.picHeight ?? 0)
                }
                
                //按钮显示状态
                strongSelf.publishBtn.isHidden = false
                switch strongSelf.topicModel?.status ?? 0 {
                case 0:
                    strongSelf.publishBtn.setTitle("活动未开始", for: .normal)
                    let color = UIColor.init(hexString: "#000000", alpha: 0.3)
                    strongSelf.publishBtn.setTitleColor(color, for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isEnabled = false
                case 1:
                    strongSelf.publishBtn.setTitle("提交作品", for: .normal)
                    strongSelf.publishBtn.setTitleColor(UIColor.black, for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isEnabled = true

                case 2:
                    strongSelf.publishBtn.setTitle("已结束", for: .normal)
                    strongSelf.publishBtn.setTitleColor(UIColor.init(hexString: "#CCCCCC"), for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isEnabled = false

                default:
                    strongSelf.publishBtn.setTitle("活动未开始", for: .normal)
                    let color = UIColor.init(hexString: "#000000", alpha: 0.3)
                    strongSelf.publishBtn.setTitleColor(color, for: .normal)
                    strongSelf.publishBtn.setBackgroundColor(UIColor.init(hexString: "#FFD444")!, forState: .normal)
                    strongSelf.publishBtn.isEnabled = false

                    
                }

                strongSelf.requestList()
            }

        }) { [weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.requestList()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension WOWWorksActivityController:UITableViewDelegate,UITableViewDataSource, WOWWorksTitleCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: titleCellID, for: indexPath) as! WOWWorksTitleCell
        cell.showData(topic: topicModel, array: fineWroksArr, lineN: line)
        cell.delegate = self
        return cell

    }

    func sortType(sort: Int) {
        sortType = sort
        pageIndex = 1
        requestList()
    }
    

}
