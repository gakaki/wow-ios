//
//  WOWMasterpieceController.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWMasterpieceController: WOWBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let cellID = String(describing: WOWMasterpieceCell.self)
    var categoryId = 0
    var fineWroksArr = [WOWFineWroksModel]()

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
        request()
    }
    override func request() {
        super.request()
        
        var params = [String: Any]()
        params = ["categoryId": categoryId   ,"type": 0 ,"startRows":0,"pageSize":10]

        WOWNetManager.sharedManager.requestWithTarget(.api_getInstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                let r = JSON(result)

                strongSelf.fineWroksArr          =  Mapper<WOWFineWroksModel>().mapArray(JSONObject: r["list"].arrayObject ) ?? [WOWFineWroksModel]()
                
                strongSelf.tableView.reloadData()

                print(r)
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
        

    }
    fileprivate func configTable(){
        tableView.estimatedRowHeight = 200
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header          = mj_header
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    
    //MARK: -- Action
    //发布
    @IBAction func publishAction(_ sender: UIButton) {
        
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWChoiceClassController.self)) as! WOWChoiceClassController
        

        self.navigationController?.pushViewController(vc, animated: true)

  
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WOWMasterpieceController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fineWroksArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWMasterpieceCell
        
        cell.showData(fineWroksArr[indexPath.row])
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            UIApplication.currentViewController()?.bingWorksDetail()
    }

}
