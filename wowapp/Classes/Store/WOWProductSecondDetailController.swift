//
//  WOWProductSecondDetailController.swift
//  wowapp
//
//  Created by 安永超 on 16/7/28.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductSecondDetailController: WOWBaseViewController {
    @IBOutlet weak var tableView:UITableView!
    var dataArray : Array<WOWProductPicTextModel> = []
    var productModel:WOWProductModel!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWGoodsSureBuyNotificationKey, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:WOWLoginSuccessNotificationKey, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    //MARK:lazy
    lazy var headView:WOWProductDetailView = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWProductDetailView), owner: self, options: nil).last as! WOWProductDetailView

        return view
    }()
    
    //MARK:Private Method
    override func setUI() {
        navigationItem.title = "详情"

        super.setUI()
        
        configTable()
        
    }
    
    private func configTable(){
        tableView.registerNib(UINib.nibName(String(WOWProductDetailCell)), forCellReuseIdentifier:String(WOWProductDetailCell))
        tableView.backgroundColor = DefaultBackColor
        tableView.estimatedRowHeight = 200
        tableView.mj_header = mj_header
        headView.showDataa(productModel)
        tableView.tableHeaderView = headView
    }
    //MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductImgDetail(productId: productModel.productID ?? ""), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                let productImgVoLit = Mapper<WOWProductPicTextModel>().mapArray(JSON(result)["productImgVoLit"].arrayObject)
                if let productImgVoLit = productImgVoLit {
                    strongSelf.dataArray = productImgVoLit
                }
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension WOWProductSecondDetailController:UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWProductDetailCell), forIndexPath: indexPath) as! WOWProductDetailCell
        let model = dataArray[indexPath.row]
        cell.productImg.kf_setImageWithURL(NSURL(string: model.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.imgDescLabel.text = model.text ?? ""
        return cell
    }
   


}



