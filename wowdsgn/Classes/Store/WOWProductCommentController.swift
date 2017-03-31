//
//  WOWProductCommentController.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/24.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class WOWProductCommentController: WOWBaseViewController {

    let cellID = String(describing: WOWProductCommentCell.self)
    let pageSize        = 10
    var commentList = [WOWProductCommentModel]()
    var product_id        = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    override func setUI() {
        super.setUI()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 50
        tableView.clearRestCell()
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        tableView.mj_header = self.mj_header
        tableView.mj_footer = self.mj_footer
        configBuyBarItem()
        navigationItem.title = "评论"
    }

   
    //MARK:Action
    //查看大图
    func loadBigImage(_ imageArray: Array<String>, _ index: Int) {
        func setPhoto() -> [PhotoModel] {
            var photos: [PhotoModel] = []
            for photoURLString in imageArray {
                
                let photoModel = PhotoModel(imageUrlString: photoURLString, sourceImageView: nil)
                photos.append(photoModel)
            }
            return photos
        }
        
        let photoBrowser = PhotoBrowser(photoModels: setPhoto()) {[weak self] (extraBtn) in
            if let sSelf = self {
                let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (sSelf.view.zj_height - 80)*0.5, width: sSelf.view.zj_width, height: 80.0))
                sSelf.view.addSubview(hud)
            }
            
        }
        
        // 指定代理
        photoBrowser.delegate = self
        photoBrowser.show(inVc: self, beginPage: index)


    }

    
    //MARK:Private Network
    override func request() {
        super.request()
        ///获取评论列表
        WOWNetManager.sharedManager.requestWithTarget(.api_ProductCommentList(pageSize: pageSize, currentPage: pageIndex, productId: product_id), successClosure: {[weak self] (result, code) in
            if let strongSelf = self{
                let r = JSON(result)
                let arr = Mapper<WOWProductCommentModel>().mapArray(JSONObject:r["productCommentList"].arrayObject)
                if let array = arr{
                    if strongSelf.pageIndex == 1{
                        strongSelf.commentList = []
                    }
                    strongSelf.commentList.append(contentsOf: array)
                    //如果请求的数据条数小于totalPage，说明没有数据了，隐藏mj_footer
                    if array.count < strongSelf.pageSize {
                        strongSelf.tableView.mj_footer = nil
                        
                    }else {
                        strongSelf.tableView.mj_footer = strongSelf.mj_footer
                    }
                }else {
                    if strongSelf.pageIndex == 1{
                        strongSelf.commentList = []
                    }
                    strongSelf.tableView.mj_footer = nil
                }
                
                strongSelf.tableView.reloadData()
                
                strongSelf.endRefresh()
            }
            
            
        }){[weak self] (errorMsg) in
            if let strongSelf = self {
                strongSelf.endRefresh()
                WOWHud.showMsgNoNetWrok(message: errorMsg)
            }
            
            
        }
    }   
}



extension WOWProductCommentController:UITableViewDelegate,UITableViewDataSource, PhotoBrowserDelegate, WOWProductCommentCellDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWProductCommentCell
        cell.showData(model: commentList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
    func photoBrowerWillDisplay(_ beginPage: Int){
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func photoBrowserWillEndDisplay(_ endPage: Int){
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //delegate
    func lookBigImage(_ index: Int, array imgArr: Array<String>) {
        loadBigImage(imgArr, index)
    }
}
