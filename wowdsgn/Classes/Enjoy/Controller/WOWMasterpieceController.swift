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
    let pageSize   = 10
    weak var delegate:WOWChideControllerDelegate?
    var backTopBtnScrollViewOffsetY : CGFloat = (MGScreenHeight - 64 - 44) * 3// 第几屏幕出现按钮

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
    //MARK:Lazy
    lazy var topBtn:UIButton = {
        var btn     = UIButton(type: UIButtonType.custom)
        btn     = btn as UIButton
        btn.setBackgroundImage(UIImage(named: "backTop"), for: UIControlState())
        btn.addTarget(self, action:#selector(backTop), for:.touchUpInside)
        return btn
    }()
    func backTop()  {
        let index  = IndexPath.init(row: 0, section: 0)
        self.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.none, animated: true)
    }

    override func setUI() {
        super.setUI()
        configTable()
        self.view.addSubview(self.topBtn)
        self.topBtn.snp.makeConstraints {[unowned self] (make) in
            make.width.equalTo(98)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(10)
        }
        self.topBtn.isHidden = true

        request()
    }
    override func pullToRefresh() {
        super.pullToRefresh()
        if let del = delegate {
            
            del.updateTabsRequsetData()
            
        }
    }
    override func request() {
        super.request()
        
        var params = [String: Any]()
        params = ["categoryId": categoryId   ,"type": 0 ,"startRows":(pageIndex-1) * 10,"pageSize":pageSize]

        WOWNetManager.sharedManager.requestWithTarget(.api_getInstagramList(params: params), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                strongSelf.endRefresh()
                
                let arr = Mapper<WOWFineWroksModel>().mapArray(JSONObject:JSON(result)["list"].arrayObject)
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
    fileprivate func configTable(){
        tableView.estimatedRowHeight = MGScreenWidth
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
        
        guard WOWUserManager.loginStatus == true else{
            
            UIApplication.currentViewController()?.toLoginVC(true)
            
            return
        }
        
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
        delayQueue.asyncAfter(deadline: .now() + 0.5) {
            
            DispatchQueue.main.async {
            
                self.changeState(alpha: 1)
            }
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.mj_offsetY < self.backTopBtnScrollViewOffsetY {
            self.topBtn.isHidden = true
        }else{
            self.topBtn.isHidden = false
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(scrollViewDidEndScrollingAnimation), with: nil, afterDelay: 0.1)
        let a = scrollView.contentOffset.y
        //        lastContentOffset = scrollView.contentOffset.y
        if a -  lastContentOffset  > 20 && a > 0{
            //            print("shang")
            lastContentOffset = a
     
            changeState(alpha: 0)
            return
        }else if lastContentOffset - a > 20 && (a  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) {
            lastContentOffset = a
       
            changeState(alpha: 1)
            return
        }
        
        
    }

    func changeState(alpha:CGFloat)  {

                UIView.animate(withDuration: 0.3) {
                    self.publishBtn.alpha = alpha
                }
      
    }

}
