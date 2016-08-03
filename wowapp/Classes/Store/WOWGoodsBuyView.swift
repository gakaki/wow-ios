//
//  WOWGoodsBuyView.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/13.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

//MARK:*****************************背景视图******************************************
enum carEntrance{
    case SpecEntrance
    case AddEntrance
    case PayEntrance
}
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
    func show(entrance: carEntrance) {
        backClear.frame = CGRectMake(0,self.h,self.w,self.h)
        addSubview(backClear)
        backClear.addSubview(buyView)
        switch entrance {
        case .SpecEntrance:
            buyView.specView.hidden = false
            buyView.entrance = .SpecEntrance
        case .AddEntrance:
            buyView.specView.hidden = true
            buyView.entrance = .AddEntrance
        case .PayEntrance:
            buyView.specView.hidden = true
            buyView.entrance = .PayEntrance
        }
        buyView.snp_makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
            }
        }
        buyView.favoriteButton.selected = WOWBuyCarMananger.sharedBuyCar.isFavorite ?? false
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
protocol goodsBuyViewDelegate:class {
    //确定购买
    func sureBuyClick(product: WOWProductInfoModel?)
    //确定加车
    func sureAddCarClick(product: WOWProductInfoModel?)
    //收藏单品
    func favoriteClick() ->Bool
   
    //分享
    func sharClick()
}


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
    @IBOutlet weak var favoriteButton: UIButton!
    
    let identifier = "WOWTagCollectionViewCell"
    var entrance : carEntrance = carEntrance.SpecEntrance
    weak var delegate: goodsBuyViewDelegate?
    //通过颜色选规格的数组
    var colorSpecArr : [WOWColorSpecModel]!
    //通过规格选颜色的数组
    var specColorArr : [WOWSpecColorModel]!
    //所有颜色的数值
    var colorArr    = Array<WOWColorNameModel>()
    //所有规格的数组
    var specArr     = Array<WOWSpecNameModel>()
    //所选颜色下标，如果为-1则没有选择颜色
    var colorIndex  = Int(-1)
    //所选规格下标，如果为-1则没有选择规格
    var specIndex   = Int(-1)
    //选择好颜色，所对应规格的数组
    var color_SpecArr : [WOWSpecModel]?
    //选好规格，所对应颜色的数组
    var spec_ColorArr : [WOWColorModel]?
    //所选产品的信息
    var productInfo : WOWProductInfoModel?
    
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
            //得到颜色的数组，并给每种颜色对应一个bool值，方便记录哪个颜色有库存
            if let array = p.colorDisplayNameList {
                for color in array {
                let colorModel = WOWColorNameModel(colorDisplayName: color, isSelect: false)
                colorArr.append(colorModel)
                }
            }
            //得到规格的数组，同样给每个规格对应一个bool值，方便记录哪个规格有库存
            if let array = p.specNameList {
                for spec in array {
                    let specModel = WOWSpecNameModel(specName: spec, isSelect: false)
                    specArr.append(specModel)
                }
            }
            //通过颜色查找规格的数组
            if let array = p.colorSpecVoList {
                colorSpecArr = array
            }
            //通过规格查找颜色的数组
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
        
        guard colorIndex >= 0 else {
            WOWHud.showMsg("请选择产品颜色")
            return
        }
        guard specIndex >= 0 else {
            WOWHud.showMsg("请选择产品规格")
            return
        }
        if let color_SpecArr = color_SpecArr {
            for product in color_SpecArr {
                if product.specName == specArr[specIndex].specName {
                    productInfo = product.subProductInfo
                    productInfo?.productQty = skuCount
                }
            }
        }
        switch entrance {
        case .AddEntrance:
            if let del = delegate {
                del.sureAddCarClick(productInfo)
            }
            print("添加购物车确定")
        case .PayEntrance:
       
             if let del = delegate {
                del.sureBuyClick(productInfo)
             }
            print("立即支付确定")
        default:
//            print("选择规格")
            return
        }
        
       
    }
    
    @IBAction func favoriteButtonClick(sender: UIButton) {
        
        if let del = delegate {
            let favorite = del.favoriteClick()
            favoriteButton.selected = !favorite
        }
        
    }
    
    @IBAction func sharButtonClick(sender: UIButton) {
        if let del = delegate {
            del.sharClick()
        }
    }
    
    @IBAction func addCarButtonClick(sender: UIButton) {
        guard colorIndex >= 0 else {
            WOWHud.showMsg("请选择产品颜色")
            return
        }
        guard specIndex >= 0 else {
            WOWHud.showMsg("请选择产品规格")
            return
        }
        if let color_SpecArr = color_SpecArr {
            for product in color_SpecArr {
                if product.specName == specArr[specIndex].specName {
                    productInfo = product.subProductInfo
                }
            }
        }

        if let del = delegate {
            del.sureAddCarClick(productInfo)
           
        }
    }
    
    @IBAction func payButtonClick(sender: UIButton) {
        guard colorIndex >= 0 else {
            WOWHud.showMsg("请选择产品颜色")
            return
        }
        guard specIndex >= 0 else {
            WOWHud.showMsg("请选择产品规格")
            return
        }
        if let color_SpecArr = color_SpecArr {
            for product in color_SpecArr {
                if product.specName == specArr[specIndex].specName {
                    productInfo = product.subProductInfo
                }
            }
        }
        
        if let del = delegate {
            del.sureBuyClick(productInfo)
            
        }
    }
    
    private func showResult(count:Int){
        self.countTextField.text = "\(count)"
    }


    
//MARK: - TagCellLayout Delegate Methods
    func tagCellLayoutTagFixHeight(layout: TagCellLayout) -> CGFloat {
        return CGFloat(44.0)
    }
    
    func tagCellLayoutTagWidth(layout: TagCellLayout, atIndex index: Int) -> CGFloat {
        if layout == collectionView?.collectionViewLayout {
            
                let item = colorArr[index]
                let title = item.colorDisplayName ?? ""
                let width = title.size(Fontlevel004).width + 50
                return width
            
        }else {
    
            let item = specArr[index]
            let title = item.specName ?? ""
            let width = title.size(Fontlevel004).width + 50
            return width
            
        }
       
    }

    
    
//MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
                let item = colorArr[indexPath.row]
                cell.textLabel.text = item.colorDisplayName
        
            if indexPath.row == colorIndex {
                updateCellStatus(cell, selected: true)
            }else {
                updateCellStatus(cell, selected: false)
            }
            //当选择产品规格的时候才会进到这个数组,通过判断所对应颜色的bool值来判断是否可选中
            if specIndex >= 0 {
                let str = colorArr[indexPath.row]
                if !str.isSelect {
                    cell.textLabel.textColor = MGRgb(234, g: 234, b: 234)
                    cell.userInteractionEnabled = false
                }
            }

            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! WOWTagCollectionViewCell
                let item = specArr[indexPath.row]
                cell.textLabel.text = item.specName
            
            if indexPath.row == specIndex {
                updateCellStatus(cell, selected: true)
            }else {
                updateCellStatus(cell, selected: false)
            }
            //当选择产品颜色的时候才会进到这个数组,通过判断所对应规格的bool值来判断是否可选中
            if colorIndex >= 0 {
                let str = specArr[indexPath.row]
                if !str.isSelect {
                    cell.textLabel.textColor = MGRgb(234, g: 234, b: 234)
                    cell.userInteractionEnabled = false
                }
                
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
                    if array.colorDisplayName == colorArr[indexPath.row].colorDisplayName{
                        color_SpecArr = array.specMapVoList
                    }
                }
            //遍历把每个规格的bool值设为false初始值，防止与上次选择的冲突
            for spec in specArr {
                spec.isSelect = false
            }
            //通过循环遍历两个数组来筛选出所选择颜色对应的规格
            if let color_SpecArr = color_SpecArr {
                for spec in color_SpecArr {
                    for selectSpec in specArr {
                        if spec.specName == selectSpec.specName {
                            selectSpec.isSelect = true
                        }
                    }
                }
                
            }
            self.collectionView.reloadData()
            secondCollectionView.reloadData()
            
        }else {
            specIndex = indexPath.row
            for array in specColorArr{
                if array.specName == specArr[indexPath.row].specName{
                    spec_ColorArr = array.colorMapVoList
                }
            }
            for color in colorArr {
                color.isSelect = false
            }
            if let spec_ColorArr = spec_ColorArr {
                for color in spec_ColorArr {
                    for selectColor in colorArr {
                        if color.colorDisplayName == selectColor.colorDisplayName {
                            selectColor.isSelect = true
                        }
                    }
                }
            }
            self.collectionView.reloadData()
            
            secondCollectionView.reloadData()
        }

    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WOWTagCollectionViewCell
        updateCellStatus(cell, selected: false)

    }
    func updateCellStatus(cell: WOWTagCollectionViewCell, selected:Bool) -> Void {
        cell.textLabel.layer.borderColor = selected ? UIColor.blackColor().CGColor : MGRgb(234, g: 234, b: 234).CGColor
        cell.textLabel.textColor = selected ? UIColor.blackColor() : MGRgb(128, g: 128, b: 128)
        cell.userInteractionEnabled = true

    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
       
        return true

    }
 
    
}

