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

    var imageArray: Array<String> = []
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.automaticallyAdjustsScrollViewInsets = false
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
        headView.size = CGSize(width: MGScreenWidth, height: 88 + headView.productDescLabel.getEstimatedHeight())
        tableView.tableHeaderView = headView
    }
    
    func setPhoto() -> [PhotoModel] {
        var photos: [PhotoModel] = []
        
        for  aa:WOWProductPicTextModel in self.dataArray{

            if let imgStr = aa.image{

                let photoModel = PhotoModel(imageUrlString: imgStr, sourceImageView: nil)
                photos.append(photoModel)
            }
        }

        
        return photos
    }

    func lookBigImg(beginPage:Int)  {
        dispatch_async(dispatch_get_main_queue()) {
        let photoBrowser = PhotoBrowser(photoModels:self.setPhoto()) {[weak self] (extraBtn) in
                if let sSelf = self {
                    let hud = SimpleHUD(frame:CGRect(x: 0.0, y: (sSelf.view.zj_height - 80)*0.5, width: sSelf.view.zj_width, height: 80.0))
                    sSelf.view.addSubview(hud)
                }
                
            }
            // 指定代理
            photoBrowser.delegate = self
            photoBrowser.show(inVc: self, beginPage: beginPage)

        }

    }
    //MARK:Private Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductImgDetail(productId: productModel.productId ?? 0), successClosure: {[weak self] (result) in
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

    func viewTap(sender:UITapGestureRecognizer) {

        self.lookBigImg((sender.view?.tag)!)
        
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
        
        cell.productImg.set_webimage_url( model.image! )
        cell.imgDescLabel.text = model.text
        cell.imgDescLabel.setLineHeightAndLineBreak(1.5)

        let gesture = UITapGestureRecognizer(target: self, action:#selector(viewTap(_:)))
        
        cell.productImg.addGestureRecognizer(gesture)
        cell.productImg.userInteractionEnabled = true
        cell.productImg.tag = indexPath.row
        
        return cell
    }
   
    


}
extension WOWProductSecondDetailController:PhotoBrowserDelegate{

    func photoBrowerWillDisplay(beginPage: Int){
         self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func photoBrowserWillEndDisplay(endPage: Int){

         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
