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
    
    lazy var dismissButton:UIButton = {
        let b = UIButton(type: .System)
        b.backgroundColor = UIColor.clearColor()
        b.addTarget(self, action: #selector(hideBuyView), forControlEvents:.TouchUpInside)
        return b
    }()
//MARK:Private Method
    private func setUP(){
        self.frame = CGRectMake(0, 0, self.w, self.h)
        backgroundColor = MaskColor
        self.alpha = 0
    }
    
    

//MARK:Actions
    func show(isSpec: Bool) {
        backClear.frame = CGRectMake(0,self.h,self.w,self.h)
        addSubview(backClear)
        backClear.addSubview(buyView)
        buyView.specView.hidden = isSpec
        buyView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
            }
        }
        
        backClear.insertSubview(dismissButton, belowSubview: buyView)
        dismissButton.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.right.equalTo(strongSelf.backClear).offset(0)
                make.bottom.equalTo(strongSelf.buyView.snp_top).offset(0)
            }
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
            self.backClear.y = self.h + 10
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
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var specView: UIView!
    let identifier = "WOWTagCollectionViewCell"

    //下面显示哪个view
    var isSpec      = Bool(false)
    //通过颜色选规格的数组
    var colorSpecArr : [WOWColorSpecModel]!
    //通过规格选颜色的数组
    var specColorArr : [WOWSpecColorModel]!
    //所有颜色的数值
    var colorArr    = Array<String>()
    //所有规格的数组
    var specArr     = Array<String>()
    //所选颜色下标，如果为-1则没有选择颜色
    var colorIndex  = Int(-1)
    //所选规格下标，如果为-1则没有选择规格
    var specIndex   = Int(-1)
    //选择好颜色，所对应规格的数组
    var color_SpecArr : [WOWSpecModel]?
    //选好规格，所对应颜色的数组
    var spec_ColorArr : [WOWColorModel]?
    
    private var skuCount:Int = 1
    private var skuPerPrice :String = ""
    private var skuName     :String = ""
    private var skuImageUrl :String = ""
    private var skuID       :String = ""
    private var productName :String = ""
    private var productID   :String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit{
        collectionView.removeObserver(self, forKeyPath: "contentSize")
        secondCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countTextField.layer.borderColor = MGRgb(234, g: 234, b: 234).CGColor
        addButton.layer.borderColor = MGRgb(234, g: 234, b: 234).CGColor
        subButton.layer.borderColor = MGRgb(234, g: 234, b: 234).CGColor
        
        defaultSetup1()
        defaultSetup2()
        configDefaultData()

    }
    

//MARK:Private Method
    func defaultSetup1() {
        //颜色视图
        let nib = UINib(nibName:"WOWTagCollectionViewCell", bundle:NSBundle.mainBundle())
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: identifier)
        let tagCellLayout = TagCellLayout(tagAlignmentType: .Left, delegate: self)
        collectionView?.collectionViewLayout = tagCellLayout
        collectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
    }
    
    func defaultSetup2() {
        //规格视图
        let nib = UINib(nibName:"WOWTagCollectionViewCell", bundle:NSBundle.mainBundle())
        secondCollectionView?.registerNib(nib, forCellWithReuseIdentifier: identifier)
        let tagCellLayout = TagCellLayout(tagAlignmentType: .Left, delegate: self)

        secondCollectionView?.collectionViewLayout = tagCellLayout
        secondCollectionView?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
    }
    
    func configDefaultData() {
        if let p = WOWBuyCarMananger.sharedBuyCar.productSpecModel{
            
            nameLabel.text = p.productName
            perPriceLabel.text  = WOWBuyCarMananger.sharedBuyCar.skuPrice.priceFormat()
           
//            goodsImageView.kf_setImageWithURL(NSURL(string: " ")!, placeholderImage:UIImage(named: "placeholder_product"))
            if let array = p.colorDisplayNameList {
                colorArr = array
            }
            if let array = p.specNameList {
                specArr = array
            }
            
            if let array = p.colorSpecVoList {
                colorSpecArr = array
            }
            if let array = p.specColorVoList{
                specColorArr = array
            }

            collectionView.reloadData()

            countTextField.text = "\(skuCount)"
        }
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
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
            DLog("颜色的collectionView的高度\(height)")

            let height2 = self.secondCollectionView.collectionViewLayout.collectionViewContentSize().height
            var endHeight2:CGFloat = 200
            if UIDevice.deviceType.rawValue < 2{
                endHeight2 = 130
            }
            
            if height2 > endHeight2 {
                self.secondCollectionViewHeight.constant = endHeight2
            }else{
                self.secondCollectionViewHeight.constant = height2
            }
            DLog("规格的collectionView的高度\(height)")

        
        
        
    }

    
//MARK:Actions    
    @IBAction func countButtonClick(sender: UIButton) {
        if sender.tag == 1001 {
            skuCount -= 1
            skuCount = skuCount == 0 ? 1 : skuCount
            showResult(skuCount)
        }else{
            skuCount += 1
            showResult(skuCount)
        }
    }
    
    @IBAction func sureButtonClick(sender: UIButton) {
        let model = WOWBuyCarModel()
        model.skuProductCount = skuCount
        model.skuName = skuName
        model.skuProductPrice = skuPerPrice
        model.skuProductImageUrl = skuImageUrl
        model.skuProductName = productName
        model.skuID = skuID
        model.productID = productID
        NSNotificationCenter.postNotificationNameOnMainThread(WOWGoodsSureBuyNotificationKey, object:model)
    }
    
    private func showResult(count:Int){
        self.countTextField.text = "\(skuCount)"
    }


    
//MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        if layout == collectionView?.collectionViewLayout {
            
                let item = colorArr[index]
                let title = item ?? ""
                let width = title.size(Fontlevel004).width + 50
                return width
            
        }else {
    
            let item = specArr[index]
            let title = item ?? ""
            let width = title.size(Fontlevel004).width + 50
            return width
            
        }
       
    }

    
    
//MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
                let item = colorArr[indexPath.row]
                cell.textLabel.text = item
            if indexPath.row == colorIndex {
                updateCellStatus(cell, selected: true)
            }else {
                updateCellStatus(cell, selected: false)
            }
            if let spec_ColorArr = spec_ColorArr {
                let str = colorArr[indexPath.row]
                for color in spec_ColorArr {
                    
                }
            }

            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
                let item = specArr[indexPath.row]
                cell.textLabel.text = item
            if indexPath.row == specIndex {
                updateCellStatus(cell, selected: true)
            }else {
                updateCellStatus(cell, selected: false)
            }
            return cell
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100 {
            return colorArr.count

        }else {
            return specArr.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.tag == 100 {
            colorIndex = indexPath.row
                for array in colorSpecArr{
                    if array.colorDisplayName == colorArr[indexPath.row]{
                        color_SpecArr = array.specMapVoList
                    }
                }
            if let color_SpecArr = color_SpecArr {
                for spec in color_SpecArr {
                    print(spec.specName)
                    
                }
            }
            self.collectionView.reloadData()

            secondCollectionView.reloadData()
            
        }else {
            specIndex = indexPath.row
            for array in specColorArr{
                if array.specName == specArr[indexPath.row]{
                    spec_ColorArr = array.colorMapVoList
                }
            }
            if let spec_ColorArr = spec_ColorArr {
                for color in spec_ColorArr {
                    print(color.colorDisplayName)
                }
            }
            self.collectionView.reloadData()
            
            secondCollectionView.reloadData()
        }
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WOWTagCollectionViewCell
//        cell.textLabel.backgroundColor = MGRgb(3, g: 3, b: 3, alpha: 0.1)
//        updateCellStatus(cell, selected: true)
//          if collectionView.tag == 100 {
//            colorIndex = indexPath.row
//            secondCollectionView.reloadData()
//            self.collectionView.reloadData()
//
//          }else {
//            specIndex = indexPath.row
//            secondCollectionView.reloadData()
//            self.collectionView.reloadData()
//        }

       
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WOWTagCollectionViewCell
        updateCellStatus(cell, selected: false)

    }
    func updateCellStatus(cell: WOWTagCollectionViewCell, selected:Bool) -> Void {
        cell.textLabel.backgroundColor = selected ? ThemeColor : MGRgb(255, g: 255, b: 255, alpha: 1)

    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        return true

    }
 
    
}

