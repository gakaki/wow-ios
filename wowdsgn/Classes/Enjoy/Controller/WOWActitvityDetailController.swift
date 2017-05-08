//
//  WOWActitvityDetailController.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/3.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWActitvityDetailController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let CellID = "WOWWorksActivityDetailCell"
    var topicId = 0
    var topicModel: WOWActivityModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MobClick.e(.learn_more_detail_page_post_picture_activity_page)
    }
    
    override func setUI() {
        super.setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.mj_header = mj_header
        tableView.separatorStyle = .none
        tableView.clearRestCell()
        tableView.register(UINib.nibName(CellID), forCellReuseIdentifier:CellID)
        
    }
    
    
    //MARK: -- NET
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_Works_Topic(topicId: topicId), successClosure: {[weak self] (result, code) in
            
            if let strongSelf = self{
                strongSelf.endRefresh()
                let r                             =  JSON(result)
                strongSelf.topicModel          =  Mapper<WOWActivityModel>().map(JSONObject: r.object )
                strongSelf.title = strongSelf.topicModel?.title
                strongSelf.tableView.reloadData()
            }
            
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showWarnMsg(errorMsg)
            }

        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
extension WOWActitvityDetailController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell                = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! WOWWorksActivityDetailCell
            cell.showData(model: topicModel)
            return cell

        
    }
    
}
