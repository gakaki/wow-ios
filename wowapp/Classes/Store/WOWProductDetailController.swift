//
//  WOWProductDetailController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailController: WOWBaseViewController {
    //Param
    var productID:String?
    var productModel                    : WOWProductModel?
    private(set) var numberSections = 0
    
    //UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var carEntranceButton: MIBadgeButton!
    
    private var shareProductImage:UIImage? //供分享使用
    lazy var placeImageView:UIImageView={  //供分享使用
        let image = UIImageView()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

//MARK:Lazy
    var cycleView:CyclePictureView! = {
        let v = CyclePictureView(frame:MGFrame(0, y: 0, width:MGScreenWidth, height:MGScreenWidth), imageURLArray: nil)
        v.placeholderImage = UIImage(named: "placeholder_banner")
        v.currentDotColor = UIColor.blackColor()
        v.otherDotColor   = UIColor.lightGrayColor()
        return v
    }()

//MARK:Private Method
    override func setUI() {
        super.setUI()
        configTable()
    }

    private func configData(){
        cycleView.imageURLArray = [productModel?.productImage ?? ""]
        likeButton.selected = (productModel?.user_isLike ?? "false") == "true"
        placeImageView.kf_setImageWithURL(NSURL(string:productModel?.productImage ?? "")!, placeholderImage:nil, optionsInfo: nil) {[weak self](image, error, cacheType, imageURL) in
            if let strongSelf = self{
                strongSelf.shareProductImage = image
            }
        }
    }
    
//MARK:Actions
    
    //MARK:立即购买
    @IBAction func buyClick(sender: UIButton) {
        
    }
    
    //MARK:放入购物车
    @IBAction func addCarClick(sender: UIButton) {
        
    }
    
    //MARK:分享
    @IBAction func shareClick(sender: UIButton) {
        
    }
    
    //MARK:喜欢
    @IBAction func likeClick(sender: UIButton) {
        
    }
    
    //MARK:选择规格
    func chooseStyle() {
        DLog("选择规格")
    }
    
    @IBAction func backClick(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
//MARK:Private Network
    override func request() {
        super.request()
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(.Api_ProductDetail(product_id: productID ?? "",uid:uid), successClosure: {[weak self] (result) in
            if let strongSelf = self{
                strongSelf.productModel = Mapper<WOWProductModel>().map(result)
                strongSelf.configData()
                strongSelf.numberSections = 5
                strongSelf.tableView.reloadData()
                strongSelf.endRefresh()
            }
        }) {[weak self](errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
            }
        }
    }
    
}





