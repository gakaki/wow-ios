//
//  WOWHotStyleNewMain.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/15.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWHotStyleNewMain: WOWBaseViewController {
    @IBOutlet var tableView: UITableView!
    var dataArr     = [WOWHomeModle]()    //商品列表数组
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.e(.Selection_Page)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "灵感"

        request()

    }
    //MARK:Private Method
    override func setUI() {
        super.setUI()
        configBuyBarItem()
        tableView.mj_header          = mj_header
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
        
        params = ["pageId": 4 as AnyObject]
        
        WOWNetManager.sharedManager.requestWithTarget(.api_Home_List(params: params), successClosure: {[weak self](result, code) in
            if let strongSelf = self{
                
                
                let json = JSON(result)
                DLog(json)
                strongSelf.endRefresh()
                
                let bannerList = Mapper<WOWHomeModle>().mapArray(JSONObject:JSON(result)["modules"].arrayObject)
                
                if let brandArray = bannerList{
                    strongSelf.dataArr = []
                    strongSelf.dataArr = brandArray
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension WOWHotStyleNewMain:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }else {
            return 15
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        if section == 1 {
            return 55
        }else {
            return 0.01
        }
      
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            return hearderView()
        }else {
            return nil
        }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
         return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotPeopleCell", for: indexPath) as! WOWHotPeopleCell
            
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotColumnCell", for: indexPath) as! WOWHotColumnCell
            cell.delegate = self
            return cell
        }
        
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WOWHotMainCell", for: indexPath) as! WOWHotMainCell
        
            return cell
        }
    }
    func hearderView() -> UIView { // 137 37
        
        let view = Bundle.main.loadNibNamed("WOWHotHeaderView", owner: self, options: nil)?.last as! WOWHotHeaderView

        return view
        
    }
}
extension WOWHotStyleNewMain:WOWHotColumnDelegate{
    func goToArticleListVC(_ columntId: Int?, title: String?) {
    
        VCRedirect.toVCArticleListVC(columntId ?? 0, title: title ?? "",isOpenTag: false,isPageView: false)
    }
}
