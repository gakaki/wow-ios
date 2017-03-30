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
    
    
    var worksId : Int?
    var modelData : WOWWorksDetailsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionIndexColor = GrayColorlevel1
        tableView.clearRestCell()
        
        navigationItem.title = "作品详情"
        //        configureSearchController()
        tableView.register(UINib.nibName("WorksDetailCell"), forCellReuseIdentifier:"WorksDetailCell")
        request()
      
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_GetWorksDetails(worksId: worksId ?? 0), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                strongSelf.modelData    =    Mapper<WOWWorksDetailsModel>().map(JSONObject:result)
                strongSelf.btnPraiseCount.setTitle(strongSelf.modelData?.totalLikeCounts?.toString, for: .normal)
                strongSelf.btnCollection.setTitle(strongSelf.modelData?.totalCollectCounts?.toString, for: .normal)
                
                strongSelf.tableView.reloadData()

                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
              
                WOWHud.dismiss()
            }
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func requestPraise() {
        
        WOWClickLikeAction.requestLikeWorksDetails(worksId: worksId ?? 0, type: 0, view: bottomView, btn: btnPraiseCount) { (Favorite) in
            
            
        }

    }
    @IBAction func clickPraise(_ sender: Any) {
        requestPraise()
    }

    @IBAction func clickCollection(_ sender: Any) {
        
    }
    @IBAction func clickShare(_ sender: Any) {

        WOWShareManager.sharePhoto("", shareText: "", url: "", shareImage: photo)

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
