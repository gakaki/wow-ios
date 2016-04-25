//
//  WOWGoodsBuyView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

//MARK:*****************************背景视图******************************************
class WOWBuyBackView: UIView {
 
//MARK:Lazy
    lazy var buyView:WOWGoodsBuyView = {
        let v = NSBundle.loadResourceName(String(WOWGoodsBuyView)) as! WOWGoodsBuyView
        v.closeButton.addTarget(self, action: #selector(closeButtonClick), forControlEvents:.TouchUpInside)
        v.userInteractionEnabled = true
        return v
    }()
    
    lazy var backClear:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK:Private Method
    private func setUP(){
        self.frame = CGRectMake(0, 0, MGScreenWidth, self.height)
        backgroundColor = MGRgb(0, g: 0, b: 0, alpha: 0.4)
        self.alpha = 0
    }

//MARK:Actions
    
    func tap() {
        hideBuyView()
    }
    
    func show() {
        backClear.frame = CGRectMake(0,self.height,self.width,self.height)
        addSubview(backClear)
        backClear.addSubview(buyView)
        buyView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalTo(backClear).offset(0)
        }
        UIView.animateWithDuration(0.3) {
            self.alpha = 1
            self.backClear.y = 0
        }
    }
    
    func closeButtonClick()  {
        hideBuyView()
    }
    
    func hideBuyView(){
        UIView.animateWithDuration(0.3, animations: {
            self.backClear.y = MGScreenHeight + 10
            self.alpha = 0
        }) { (ret) in
            self.removeFromSuperview()
        }
    }
    
    
}


//MARK **********************************内容视图***********************************

class WOWGoodsBuyView: UIView,TagCellLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource{
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var perPriceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var dataArr = WOWBuyCarMananger.sharedBuyCar.producModel?.skus
    
    private var buyCount:Int = 1
    private var perPrice:String = "0"
    private var typeString:String?
    
    var token: dispatch_once_t = 0
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    lazy var skuModel:WOWBuyCarModel = WOWBuyCarModel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit{
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultSetup()
    }
    

//MARK:Private Method
    func defaultSetup() {
        let nib = UINib(nibName:"WOWTagCollectionViewCell", bundle:NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: "WOWTagCollectionViewCell")
        let tagCellLayout = TagCellLayout(tagAlignmentType: .Left, delegate: self)
        if let p = WOWBuyCarMananger.sharedBuyCar.producModel{
            nameLabel.text = p.productName
            perPriceLabel.text  = p.price?.priceFormat()
            goodsImageView.kf_setImageWithURL(NSURL(string:p.productImage ?? " ")!, placeholderImage:UIImage(named: "placeholder_product"))
            skuModel.skuProductName = p.productName ?? ""
            skuModel.skuName = p.skus?.first?.skuTitle ?? ""
            skuModel.skuProductPrice = p.price ?? ""
            skuModel.skuProductCount = 1
            skuModel.skuProductImageUrl = p.productImage ?? ""
        }
        collectionView?.collectionViewLayout = tagCellLayout
        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
        collectionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), animated: true, scrollPosition: .None)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        dispatch_once(&token) {
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize().height
            var endHeight:CGFloat = 200
            if UIDevice.deviceType.rawValue < 2{
                endHeight = 130
            }
            
            if height > endHeight {
                self.collectionViewHeight.constant = endHeight
            }else{
                self.collectionViewHeight.constant = height
            }
            DLog("规格的collectionView的高度\(height)")
        }
    }

    
//MARK:Actions    
    @IBAction func countButtonClick(sender: UIButton) {
        if sender.tag == 1001 {
            buyCount -= 1
            buyCount = buyCount == 0 ? 1 : buyCount
            showResult(buyCount)
        }else{
            buyCount += 1
            showResult(buyCount)
        }
    }
    
    @IBAction func sureButtonClick(sender: UIButton) {
        skuModel.skuProductCount = buyCount
        NSNotificationCenter.postNotificationNameOnMainThread(WOWGoodsSureBuyNotificationKey, object:skuModel)
    }
    
    private func showResult(count:Int){
        self.countTextField.text = "\(buyCount)"
    }


    
//MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat {
        return CGFloat(50.0)
    }
    
    func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        if let arr = dataArr {
            let item = arr[index]
            let title = item.skuTitle ?? ""
            let width = title.size(Fontlevel004).width + 50
            return width
        }
        return 0
    }

    
    
//MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "WOWTagCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
        if let arr = dataArr {
            let item = arr[indexPath.row]
            cell.textLabel.text = item.skuTitle
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr == nil ? 0 : (dataArr?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let arr = dataArr {
            let model = arr[indexPath.item]
            perPriceLabel.text = model.skuPrice?.priceFormat()
            skuModel.skuProductPrice = model.skuPrice ?? ""
            skuModel.skuName  = model.skuTitle ?? ""
        }
    }
    
}


//class PostBuyModel{
//    var count:Int = 0
//    var perPrice:String = ""
//        /// 产品规格
//    var typeStrng:String = ""
//    init(count:Int,price:String,typeString:String?){
//        self.count = count
//        self.perPrice = price
//        self.typeStrng = typeString ?? ""
//    }
//    
//    
//}




