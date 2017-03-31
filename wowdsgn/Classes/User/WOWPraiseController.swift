//
//  WOWPraiseController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWPraiseController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellOneID = String(describing: WOWPraiseOneCell.self)
    let cellTwoID = String(describing: WOWPraiseTwoCell.self)

    var dataArr  = [WOWWorksListModel]()
    
    let pageSize   = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationShadowImageView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationShadowImageView?.isHidden = false
    }
    override func setUI() {
        super.setUI()
        configTable()
    }
    
    fileprivate func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellOneID), forCellReuseIdentifier:cellOneID)
        tableView.register(UINib.nibName(cellTwoID), forCellReuseIdentifier:cellTwoID)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
    
    func customViewForEmptyDataSet(_ scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: WOWWorkdEmptyView.self), owner: self, options: nil)?.last as! WOWWorkdEmptyView
        
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    

    //MARK:Network
    override func request() {
        super.request()
        let startRows = (pageIndex - 1) * pageSize
        let params = ["startRows":startRows,"pageSize":pageSize,"type":1]
        WOWNetManager.sharedManager.requestWithTarget(.api_WorksList(params: params as [String : AnyObject]), successClosure: { [weak self](result, code) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWWorksListModel>().mapArray(JSONObject:JSON(result)["list"].arrayObject)
                if let array = arr{
                    
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.dataArr.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                    
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.dataArr = []
                    }
                    strongSelf.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                strongSelf.tableView.reloadData()
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self {
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

extension WOWPraiseController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        switch model.type ?? 0 {
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellTwoID, for: indexPath) as! WOWPraiseTwoCell
            cell.showData(model: model)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellOneID, for: indexPath) as! WOWPraiseOneCell
            cell.showData(model: model)
            return cell
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        VCRedirect.bingWorksDetails(worksId: model.id ?? 0)
    }
    
}
