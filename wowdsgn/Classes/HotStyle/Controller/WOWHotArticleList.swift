//
//  WOWHotArticleList.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/16.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWHotArticleList: WOWBaseViewController {
    @IBOutlet var tableView: UITableView!
    var dataArr     = [WOWHotStyleModel]()    //商品列表数组
    var titleVC     : String?
    var columnId    = 0 // 栏目ID
    var keyId       : String!// tagid - columnId
    var valuePageView       : String!  // page - topic
    var isPageView  :Bool?{// 为true 则是从专题详情内点击进来
        didSet{
            if isPageView ?? false {
                valuePageView = "topic"
            }else{
                valuePageView = "page"
            }
        }
    }
    
    var isOpenTag  :Bool?{// 为true  则是点击的标签 进来的
        didSet{
            if isOpenTag ?? false {
                keyId = "tagId"
            }else{
                keyId = "columnId"
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 410
        tableView.register(UINib.nibName("WOWHotMainCell"), forCellReuseIdentifier: "WOWHotMainCell")
        tableView.register(UINib.nibName("WOWHotPeopleCell"), forCellReuseIdentifier: "WOWHotPeopleCell")
        tableView.register(UINib.nibName("WOWHotColumnCell"), forCellReuseIdentifier: "WOWHotColumnCell")
    }
    override func request() {
        super.request()
        var params = [String: AnyObject]()
        
        let totalPage = 10
        
        params = ["currentPage": pageIndex as AnyObject,"pageSize":totalPage as AnyObject,keyId:columnId as AnyObject,"channel":valuePageView as AnyObject]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_HotStyle_BottomList(params : params), successClosure: {[weak self] (result,code) in
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                
                let json = JSON(result)
                DLog(json)

                strongSelf.mj_footer.endRefreshing()
                let bannerList = Mapper<WOWHotStyleModel>().mapArray(JSONObject:JSON(result)["topics"].arrayObject)
                
                if let bannerList = bannerList{
                    if strongSelf.pageIndex == 1{// ＝1 说明操作的下拉刷新 清空数据
                        strongSelf.dataArr = []
//                        strongSelf.dataDelegate?.isOverBottomData = false
                        
                    }

                    if bannerList.count < totalPage {// 如果拿到的数据，小于分页，则说明，无下一页
                        strongSelf.tableView.mj_footer = nil
//                        strongSelf.dataDelegate?.isOverBottomData = true
                        
                        
                    }else {

                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                    
                    strongSelf.dataArr.append(contentsOf: bannerList)
//                    strongSelf.dataDelegate?.bottomHotListArray = strongSelf.bottomListArray
                    
                }else {
                    
                    
                    strongSelf.tableView.mj_footer = nil
                    
                }
                strongSelf.tableView.reloadData()
                WOWHud.dismiss()
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        }
        
    }

}
extension WOWHotArticleList:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {

            return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            return 15

        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            return nil
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotMainCell", for: indexPath) as! WOWHotMainCell
 
        let model = dataArr[indexPath.section]
        cell.showData(model)

        cell.selectionStyle   = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.section]
        
        let vc = UIStoryboard.initialViewController("HotStyle", identifier:String(describing: WOWContentTopicController.self)) as! WOWContentTopicController

        vc.topic_id = model.id ?? 0
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
//        toVCTopidDetail(model.id ?? 0)
    }
    func hearderView() -> UIView { // 137 37
        
        let view = Bundle.main.loadNibNamed("WOWHotHeaderView", owner: self, options: nil)?.last as! WOWHotHeaderView
        
        return view
        
    }
}
extension WOWHotArticleList:WOWHotStyleDelegate{
    
    func reloadTableViewData(){
        
        self.request()
        
    }
    
}
