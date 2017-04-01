//
//  WOWWorksDetailsController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWWorksDetailsController: WOWBaseViewController {
    var photo : UIImage?
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnPraiseCount: UIButton!
    
    @IBOutlet weak var btnCollection: UIButton!
    
    @IBOutlet var bottomView: UIView!
    
    var isBoolFormReleaseVC : Bool = false // 是否从发布页进来 默认为false
    
    var worksId : Int?
    var modelData : WOWWorksDetailsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionIndexColor = GrayColorlevel1
        tableView.mj_header = mj_header
        tableView.clearRestCell()
        
        navigationItem.title = "作品详情"
        //        configureSearchController()
        tableView.register(UINib.nibName("WorksDetailCell"), forCellReuseIdentifier:"WorksDetailCell")
      
        request()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          setLeftBack()
    }
    func setLeftBack() {
//        if navigationController?.viewControllers.count > 1 {
            let item = UIBarButtonItem(image:UIImage(named: "nav_backArrow"), style:.plain, target: self, action:#selector(backAction))
            navigationItem.leftBarButtonItem = item
//        }
    }
    
    func backAction() {
        if self.isBoolFormReleaseVC {

            self.navigationController?.dismiss(animated: true) {
                _ = FNUtil.currentTopViewController().navigationController?.popViewController(animated: true)
            }
    
        }else {
            _ = navigationController?.popViewController(animated: true)
        }
       
    }

    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetWorksDetails(worksId: worksId ?? 0), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                strongSelf.endRefresh()
                strongSelf.modelData    =    Mapper<WOWWorksDetailsModel>().map(JSONObject:result)
                strongSelf.btnPraiseCount.setTitle(strongSelf.modelData?.likeCounts?.toString, for: .normal)
                strongSelf.btnCollection.setTitle(strongSelf.modelData?.collectCounts?.toString, for: .normal)
                strongSelf.btnPraiseCount.isSelected = strongSelf.modelData?.like ?? false
                strongSelf.btnCollection.isSelected = strongSelf.modelData?.collect ?? false
                
                if strongSelf.modelData?.myInstagram ?? false {
                    strongSelf.btnCollection.isEnabled = false
                    
                }
                strongSelf.tableView.reloadData()

                
            }
            }, failClosure: {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
        })
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - 点赞作品
    func requestPraise() {
        if let model = self.modelData { // 喜欢的类型  取反
            if let like = model.like {
                var likeType = 0
                if like {
                    likeType = 0
                }else {
                    likeType = 1
                }
                WOWClickLikeAction.requestLikeWorksDetails(worksId: worksId ?? 0, type: likeType, view: bottomView, btn: btnPraiseCount) {[weak self] (Favorite) in
                    if let strongSelf = self {
                        model.like = !like
                        strongSelf.btnPraiseCount.isSelected = model.like ?? false
                        model.likeCounts = Calculate.calculateType(type: !like)(model.likeCounts ?? 0)
                        strongSelf.btnPraiseCount.setTitle(model.likeCounts?.toString, for: .normal)
                    }
                }
           
            }
           
        }

    }
    // MARK: - 收藏作品
    func requestCollect() {
        if let model = self.modelData { // 喜欢的类型  取反
            if let collect = model.collect {
                var collectType = 0
                if collect {
                    collectType = 0
                }else {
                    collectType = 1
                }
                WOWClickLikeAction.requestCollectWorksDetails(worksId: worksId ?? 0, type: collectType, view: bottomView, btn: btnCollection) {[weak self] (Favorite) in
                    if let strongSelf = self {
                        
                        model.collect = !collect
                        strongSelf.btnCollection.isSelected = model.collect ?? false
                        model.collectCounts = Calculate.calculateType(type: !collect)(model.collectCounts ?? 0)
                        strongSelf.btnCollection.setTitle(model.collectCounts?.toString, for: .normal)

                    }
                    
                }
            }
            
        }
        
    }

    @IBAction func clickPraise(_ sender: Any) {
        requestPraise()
    }

    @IBAction func clickCollection(_ sender: Any) {
        requestCollect()
    }
    @IBAction func clickShare(_ sender: Any) {
        
        if let modelData = self.modelData {
            WOWShareManager.sharePhoto(modelData)
        }

    }


}
extension WOWWorksDetailsController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WorksDetailCell", for: indexPath) as! WorksDetailCell
        
        if let photo = photo {
            
         cell.imgPhoto.image = photo
            
        }
        
        cell.selectionStyle = .none
        if let model = self.modelData {
            cell.showData(model)
        }
        
        return cell
        
    }
}
