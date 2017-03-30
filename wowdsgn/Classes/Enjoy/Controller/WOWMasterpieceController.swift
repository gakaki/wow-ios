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
    var lastContentOffset :CGFloat = 0.0 
    @IBOutlet weak var publishBtn: UIButton!
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
        params = ["categoryId": categoryId   ,"type": 0 ,"startRows":(pageIndex-1) * 10,"pageSize":10]

        WOWNetManager.sharedManager.requestWithTarget(.api_getInstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                let r = JSON(result)

                strongSelf.fineWroksArr          =  Mapper<WOWFineWroksModel>().mapArray(JSONObject: r["list"].arrayObject ) ?? [WOWFineWroksModel]()
                
                
                //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                if strongSelf.fineWroksArr.count < 10 {
                    strongSelf.tableView.mj_footer = nil
                    
                }else {
                    strongSelf.tableView.mj_footer = strongSelf.mj_footer
                }
                
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
        tableView.mj_footer          = mj_footer
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
        let model = fineWroksArr[indexPath.row]
        VCRedirect.bingWorksDetails(worksId: model.id ?? 0)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let delayQueue = DispatchQueue.global()
        delayQueue.asyncAfter(deadline: .now() + 1.0) {
            
            DispatchQueue.main.async {
                //                WOWHud.dismiss()
                //                strongSelf.popVC()
                self.changeState(alpha: 1)
            }
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.1)
        let a = scrollView.contentOffset.y
        //        lastContentOffset = scrollView.contentOffset.y
        if a -  lastContentOffset  > 50{
            //            print("shang")
            lastContentOffset = a
//            hidden = true
            changeState(alpha: 0)
            return
        }else if lastContentOffset - a > 50 {
            lastContentOffset = a
//            hidden = false
            changeState(alpha: 1)
            return
        }
        
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let a = scrollView.contentOffset.y
        if a -  lastContentOffset  > 50{
            //            print("shang")
            lastContentOffset = a
//            hidden = true
            changeState(alpha: 0)
            return
        }else if lastContentOffset - a > 50 {
            lastContentOffset = a
//            hidden = false
            changeState(alpha: 1)
            return
        }
        
        
    }
    
    func changeState(alpha:CGFloat)  {
        UIView.animate(withDuration: 0.3) {
            self.publishBtn.alpha = alpha
        }
    }

    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        lastContentOffset = scrollView.contentOffset.y
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        if lastContentOffset < scrollView.contentOffset.y {
////            print("shang")
//        }else{
////            print("xia")
//        }
//        
//    }
}
