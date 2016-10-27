
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
    
    case addEntrance    //添加购物车
    case payEntrance    //立即支付
}
class WOWBuyBackView: UIView {
//MARK:Lazy
    lazy var buyView:WOWGoodsBuyView = {
        let v = Bundle.loadResourceName(String(describing: WOWGoodsBuyView.self)) as! WOWGoodsBuyView
        v.closeButton.addTarget(self, action: #selector(closeButtonClick), for:.touchUpInside)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var backClear:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
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
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.clear
//        b.addTarget(self, action: #selector(hideBuyView), forControlEvents:.TouchUpInside)
        return b
    }()
//MARK:Private Method
    fileprivate func setUP(){
        self.frame = CGRect(x: 0, y: 0, width: self.w, height: self.h)
        backgroundColor = MaskColor
        self.alpha = 0
    }
    
    

//MARK:Actions
    func show(_ entrance: carEntrance) {
        backClear.frame = CGRect(x: 0,y: self.h,width: self.w,height: self.h)
        addSubview(backClear)
//        buyView.productSpecModel = productSpec
//        buyView.configDefaultData()
        backClear.addSubview(buyView)
        switch entrance {
        case .addEntrance:
        
            buyView.entrance = .addEntrance
        case .payEntrance:
           
            buyView.entrance = .payEntrance
        }
        buyView.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(MGScreenHeight*0.75)
            }
        }
       
        backClear.insertSubview(dismissButton, belowSubview: buyView)
        dismissButton.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.right.equalTo(strongSelf.backClear).offset(0)
                make.bottom.equalTo(strongSelf.buyView.snp.top).offset(0)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.backClear.y = 0
        }) 
    }
    
    func closeButtonClick()  {
        hideBuyView()
    }
    
    func hideBuyView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backClear.y = self.h + 10
            self.alpha = 0
        }, completion: { (ret) in
            self.removeFromSuperview()
        }) 
    }
    
    
}


//MARK **********************************内容视图***********************************
protocol goodsBuyViewDelegate:class {
    //确定购买
    func sureBuyClick(_ product: WOWProductModel?)
    //确定加车
    func sureAddCarClick(_ product: WOWProductModel?)
    //关掉选择规格视图
    func closeBuyView(_ productInfo: WOWProductModel?)
}


class WOWGoodsBuyView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ProductSpecFootViewDelegate{
    @IBOutlet weak var perPriceLabel: UILabel!          //商品价格
    @IBOutlet weak var originalPriceLabel: UILabel!      //商品原价
    @IBOutlet weak var sizeTextLabel: UILabel!          //商品尺寸
    @IBOutlet weak var weightLabel: UILabel!            //商品重量
    @IBOutlet weak var collectionView: UICollectionView!    //颜色标签
    @IBOutlet weak var nameLabel: UILabel!              //商品名字
    @IBOutlet weak var goodsImageView: UIImageView!     //商品图片
    @IBOutlet weak var closeButton: UIButton!
    
 
    @IBOutlet weak var sureButton: UIButton!            //确定按钮
  
    fileprivate var _layer: CALayer!
    fileprivate var path: UIBezierPath!

    
    let identifier = "WOWSearchCell"
    var entrance : carEntrance = carEntrance.addEntrance
    weak var delegate: goodsBuyViewDelegate?
    
    //产品规格
    var productSpecModel    : WOWProductSpecModel?
    //规格数组
    var serialAttributeArr  = [WOWSerialAttributeModel]()
    //sku列表
    var skuListArr          = [WOWProductModel]()
    //当前产品
    //各种规格的选择状态
    var seributeDic         = [Int: Bool]()
    

    //所选产品的信息
    var productInfo : WOWProductModel?
    //未选择规格
    var selectSpec = false
    //是否全选中
    var allSelect = true
    
    fileprivate var skuCount:Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit{
  
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        defaultSetup()
        configDefaultData()

    }
    lazy var layout: UICollectionViewLeftAlignedLayout = {
        let layout = UICollectionViewLeftAlignedLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        return layout
        
    }()

//MARK:Private Method
    func defaultSetup() {
        
        //设置布局
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.nibName(String(describing: WOWSearchCell.self)), forCellWithReuseIdentifier: "WOWSearchCell")
        
   
        collectionView.register(UINib.nibName(String(describing: WOWProductSpecReusableView.self)), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWProductSpecReusableView")
        
        collectionView.register(UINib.nibName(String(describing: WOWProductSpecFootView.self)), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WOWProductSpecFootView")
    }
    
 
    
    func configDefaultData() {
        if let p = WOWBuyCarMananger.sharedBuyCar.productSpecModel{
            productSpecModel = p
            if let productArray = p.products {
                for product in productArray {
                    if product.productId == WOWBuyCarMananger.sharedBuyCar.productId {
                        productInfo = product
                    }
                }
            }
            goodsImageView.borderColor(0.5, borderColor: MGRgb(234, g: 234, b: 234))
            configProductInfo()
            //规格数组
            if let array = p.serialAttribute {
                serialAttributeArr = array
            }
            //产品列表的数组
            if let array = p.products {
                skuListArr = array
            }
            if let attributes = productInfo?.attributes {
                for proSpec in attributes.enumerated() {
                    for serial in serialAttributeArr[proSpec.offset].specName {
                        if proSpec.element.attributeValue == serial.specName {
                            serial.isSelect = true
                            continue
                        }
                    }
                }
            }
            productSku()
        }
    }
    
    func configProductInfo() {
        if let productInfo = productInfo {
            goodsImageView.set_webimage_url(productInfo.productImg)
            nameLabel.text = productInfo.productTitle ?? ""
            let result = WOWCalPrice.calTotalPrice([productInfo.sellPrice ?? 0],counts:[1])
            perPriceLabel.text = result
            if let originalPrice = productInfo.originalprice {
                if originalPrice > productInfo.sellPrice{
                    //显示下划线
                    let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                    
                    originalPriceLabel.setStrokeWithText(result)
                    
                }else {
                    originalPriceLabel.text = ""
                }
            }
            sizeTextLabel.text = productSize(productInfo: productInfo)
            weightLabel.text = productWeight(productInfo: productInfo)
            if productInfo.productStatus == 1 {
                productStock(productInfo.hasStock ?? false)
            }
            //当产品状态为2的时候商品已下架
            if productInfo.productStatus == 2 {
                productUndercarriage()
            }
        }
    }
    

    
//MARK:Actions
 
    
    /**
     确定按钮分为两个入口
     1. 从加入购物车进来，点击确定按钮购物车数量+1 ，加车动画，并且回到商品详情页
     2. 从立即支付进来，点击确定直接进入到确认订单页
     
     */
    @IBAction func sureButtonClick(_ sender: UIButton) {
        
        if !validateMethods(){
            return
        }
        self.productInfo?.productQty = skuCount
        switch entrance {
        case .addEntrance:
            startAnimationWithRect(goodsImageView.frame, ImageView: goodsImageView)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[weak self](void) in
                if let strongSelf = self {
                    if let del = strongSelf.delegate {
                        strongSelf.productInfo?.productQty = strongSelf.skuCount
                        
                        del.sureAddCarClick(strongSelf.productInfo)
                        del.closeBuyView(strongSelf.productInfo)
                    }
                }
               
            })

        case .payEntrance:
       
             if let del = delegate {
                del.sureBuyClick(productInfo)
             }
        default:
//            print("选择规格")
            return
        }
        
       
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        if let del = delegate {
            del.closeBuyView(productInfo)
        }
    }

    /**
     加入购物车
     
     */
//    @IBAction func addCarButtonClick(_ sender: UIButton) {
//        if !validateMethods(){
//            return
//        }
//
//        startAnimationWithRect(goodsImageView.frame, ImageView: goodsImageView)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
//            
//            if let del = self.delegate {
//                self.productInfo?.productQty = self.skuCount
//                
//                del.sureAddCarClick(self.productInfo)
//                    
//            }
//        })
//        
//    }
//    /**
//     立即支付
//    
//     */
//    @IBAction func payButtonClick(_ sender: UIButton) {
//        if !validateMethods(){
//            return
//        }
//        
//        if let del = delegate {
//            self.productInfo?.productQty = skuCount
//            del.sureBuyClick(productInfo)
//            
//        }
//    }

    
    //MARK: - validate Methods
    fileprivate func validateMethods() -> Bool{
        selectSpec = true
        for spec in serialAttributeArr.enumerated() {
            
            if !(seributeDic[spec.offset] ?? false) {
                WOWHud.showMsg("请选择" + (spec.element.attributeShowName ?? ""))
                collectionView.reloadData()
                return false
            }
        }
        collectionView.reloadData()
        return true
    }


    
    
//MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WOWSearchCell
        let spec = serialAttributeArr[indexPath.section].specName[indexPath.row]
        cell.titleLabel.text = spec.specName
        updateCellStatus(cell, selected: spec.isSelect)
        if !spec.isCanSelect {
            updateCellUnSelect(cell, isCanSelected: spec.isCanSelect)
        }
        //每组的数据
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return serialAttributeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serialAttributeArr[section].attributeValues?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.orange
        let attributeValues = serialAttributeArr[indexPath.section].specName
        if attributeValues.count > 0 {
            for spec in attributeValues.enumerated() {
                /**
                 *  点击选择规格,选中的改变按钮颜色
                 */
                if spec.offset == indexPath.row {
                    spec.element.isSelect = !spec.element.isSelect
                }else {
                    spec.element.isSelect = false
                }
                
                
            }
            //把所有有可能的sku都加到一个数组中
            productSku()
        }
        
    }
    

    

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        var reusableView:UICollectionReusableView?
        //是每组的头
        if (kind == UICollectionElementKindSectionHeader){
            
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWProductSpecReusableView", for: indexPath) as? WOWProductSpecReusableView
            searchReusable?.specLabel.text = serialAttributeArr[indexPath.section].attributeShowName
            if selectSpec {
                searchReusable?.warnImg.isHidden = seributeDic[indexPath.section] ?? false
            }else {
                searchReusable?.warnImg.isHidden = true
            }
            
            reusableView = searchReusable!
        }
        if (kind == UICollectionElementKindSectionFooter){
            if indexPath.section == serialAttributeArr.count - 1 {
                let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WOWProductSpecFootView", for: indexPath) as? WOWProductSpecFootView
                searchReusable?.delegate = self
                searchReusable?.showResult(skuCount)
                reusableView = searchReusable!
            }
            
        }
        
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: MGScreenWidth, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == serialAttributeArr.count - 1 {
            return CGSize(width: MGScreenWidth, height: 82)
        }else {
            return CGSize(width: MGScreenWidth, height: 0)
        }
        
    }
    //MARK - UICollectionViewDelegateFlowLayout  itme的大小
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if serialAttributeArr.count > 0 {
            let text = serialAttributeArr[indexPath.section].specName[indexPath.row].specName
            let size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil).size
            return CGSize(width: size.width+32, height: 35)
        }
        
        return CGSize(width: 80, height: 35)
      
        
        
    }
    //MARK - ProductSpecFootViewDelegate
    func countClick(_ sender: UIButton!) {
        /**
         *  更改商品数量，商品数量为1时不能再减少
         *  加商品时要判断商品的库存数量和已加商品数，如果库存数大于购买数可以继续增加
         *  如果库存数小于等于购买数，则提示库存不足
         */
        if sender.tag == 1001 {
            skuCount -= 1
            skuCount = skuCount == 0 ? 1 : skuCount

        }else{
            if allSelect && productInfo?.productStatus == 1 {
                    if productInfo?.availableStock! > skuCount {
                        skuCount += 1
                    }else {
                        WOWHud.showMsg("库存不足")
                    }
            }else {
                skuCount += 1
            }
        }
        collectionView.reloadData()
    }
    
    
    //更新cell点击状态
    func updateCellStatus(_ cell: WOWSearchCell, selected:Bool) -> Void {
        
        
        cell.titleLabel.backgroundColor = selected ? UIColor(hexString: "#FFD444") : UIColor(hexString: "#F5F5F5")
        cell.titleLabel.textColor = UIColor(hexString: "#000000")
        cell.isUserInteractionEnabled = true
        
    }
    //cell不可点击状态
    func updateCellUnSelect(_ cell: WOWSearchCell, isCanSelected:Bool) -> Void {
        cell.titleLabel.backgroundColor = UIColor(hexString: "#F5F5F5")
        
        if isCanSelected {
            cell.titleLabel.textColor = UIColor(hexString: "#000000")
            cell.isUserInteractionEnabled = true
        }else{
            cell.titleLabel.textColor = UIColor(hexString: "#CCCCCC")
            cell.isUserInteractionEnabled = false
        }
        
    }

   
    
    
    /**
     商品有无库存
     */
    func productStock(_ hasStock: Bool) {
        if hasStock {
            
            //如果所加数量大于已有库存，则显示库存最大数
            if let availableStock = self.productInfo?.availableStock {
                if availableStock < skuCount {
                    skuCount = (self.productInfo?.availableStock)!

                }
            }
            if skuCount == 0 {
                skuCount = 1
            }
            sureButton.setBackgroundColor(MGRgb(32, g: 32, b: 32), forState: .normal)
            sureButton.isEnabled = true
            sureButton.setTitle("确定", for: .normal)
            
        }else {
            skuCount = 0
           
            
            sureButton.setBackgroundColor(MGRgb(204, g: 204, b: 204), forState: .disabled)
            sureButton.isEnabled = false
            sureButton.setTitle("已售罄", for: .disabled)
        }
        collectionView.reloadData()
    }

    /**
     商品已下架
     */
    func productUndercarriage() {
        
            sureButton.setBackgroundColor(MGRgb(204, g: 204, b: 204), forState: .disabled)
            sureButton.isEnabled = false
            sureButton.setTitle("已下架", for: .disabled)
    }
    

    
}
extension WOWGoodsBuyView {
    func productSku()  {
        //每次做筛选的时候首先把所有的状态设为可点击状态
        for att in serialAttributeArr {
            for spec in att.specName {
                spec.isCanSelect = true
            }
        }
        
        var productArray = skuListArr
        //由于不知道有几个规格选择，循环遍历所有规格的数组，如果某个被选中则进入判断，筛选出其他几个规格中的按钮点击状态
        for attribute in serialAttributeArr.enumerated() {
            //为了记录有哪几个规格已选中
            seributeDic[attribute.offset] = false
            let array = attribute.element.specName
            
            //循环遍历规格的数组。如果选中某个规格则筛选出sku列表中包含这个规格的产品
            for spec in array {
                //如果这个选项是已选择的，先建一个空的字典，存放被筛选出来的其他规格，有几种分为几个数组。
                if spec.isSelect {
                    //如果已经选中了则状态置为true
                    seributeDic[attribute.offset] = true
                    var dic = [Int: [WOWSpecNameModel]]()
                    var index = 0
                    for a in serialAttributeArr.enumerated() {
                        dic[a.offset] = [WOWSpecNameModel]()
                    }
                    //遍历所有有可能的产品列表
                    for attri in skuListArr {
                        //如果所选择的规格和对应产品sku里面有。则把这个产品拿出来
                        
                        if spec.specName == attri.attributes?[attribute.offset].attributeValue {
                            
                            //再遍历所筛选出来产品的对应的规格。除去选中的那个，存下其余规格。下标作为key，
                            for a in (attri.attributes?.enumerated())! {
                                if a.offset == attribute.offset {
                                    print(a.element.attributeValue)
                                    index = a.offset
                                }else {
                                    
                                    for spe in serialAttributeArr[a.offset].specName {
                                        
                                        if a.element.attributeValue == spe.specName {
                                            dic[a.offset]?.append(spe)
                                            
                                        }
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                        }else {
                            productArray.removeObject(attri)
                        }
                        
                        
                    }
                    for spe in serialAttributeArr.enumerated(){
                        if spe.offset == index {
                            
                        }else {
                            for a in spe.element.specName {
                                if (dic[spe.offset]?.contains(a)) ?? false {
                                    
                                }else {
                                    a.isCanSelect = false
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        
        allSelect = true
        for spec in serialAttributeArr.enumerated() {
            
            if !(seributeDic[spec.offset] ?? false) {
                allSelect = false
            }
        }
        
        if allSelect {
            if productArray.count > 0 {
                productInfo = productArray[0]
                configProductInfo()
            }
        }else {
            productStock(true)
        }
        collectionView.reloadData()

    }
}

//MARK: - 添加购物车动画
extension WOWGoodsBuyView:CAAnimationDelegate {

    func startAnimationWithRect(_ rect: CGRect, ImageView imageView:UIImageView)
    {
        if _layer == nil {
            
            _layer = CALayer()
            _layer.contents = imageView.layer.contents
            
            _layer.contentsGravity = kCAGravityResizeAspectFill
            _layer.frame = rect
            // 导航64
            _layer.position = CGPoint(x: imageView.center.x, y: rect.midY);
            self.layer.addSublayer(_layer)
            
            self.path = UIBezierPath()
            self.path.move(to: _layer.position)
            
            //动画移动的位置
            self.path.addQuadCurve(to: CGPoint(x: MGScreenWidth - 22, y: -MGScreenHeight + self.size.height + 42), controlPoint: CGPoint(x: 50, y: -MGScreenHeight/4))
            
            
        }
        self.groupAnimation()
    }
    
    func groupAnimation()
    {
        self.isUserInteractionEnabled = false
    
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        animation.path = self.path.cgPath
        
        //旋转动画
//        let expandAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z")
//        
//        expandAnimation1.duration = 1.0
//        expandAnimation1.repeatCount = 1
//        expandAnimation1.fromValue = NSNumber(float: 0.0)
//        expandAnimation1.toValue = NSNumber(double: 10 * M_PI)
        
        
        //到中间的动画
        let expandAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        expandAnimation.duration = 0.4
        expandAnimation.fromValue = NSNumber(value: 1 as Float)
        expandAnimation.toValue = NSNumber(value: 0.7 as Float)
        
        expandAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //从中间到购物车的动画
        
        let narrowAnimation = CABasicAnimation(keyPath: "transform.scale")
        
        narrowAnimation.beginTime = 0.4
        narrowAnimation.fromValue = NSNumber(value: 0.7 as Float)
        narrowAnimation.duration = 0.4
        narrowAnimation.toValue = NSNumber(value: 0.3 as Float)
        
        narrowAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let groups = CAAnimationGroup()
        
        groups.animations = [animation,expandAnimation,narrowAnimation]
        groups.duration = 0.8
        groups.isRemovedOnCompletion=false
        groups.fillMode =    kCAFillModeForwards
        groups.delegate = self
        self._layer.add(groups, forKey: "group")
        
    }
     func animationDidStop(_ anim: CAAnimation, finished flag:Bool)
    {
        
        if anim == self._layer.animation(forKey: "group"){
            self.isUserInteractionEnabled = true
            self._layer.removeFromSuperlayer()
            
            self._layer = nil
           
        }
    }

    /**
     *  格式化产品尺寸
     */
    func productSize(productInfo: WOWProductModel) -> String {
        let format = String(format:"尺寸：L%.0f×W%.0f×H%.0fcm",productInfo.length ?? 0, productInfo.width ?? 0, productInfo.height ?? 0)
        return format
    }
    /**
     *  格式化产品尺寸重量
     */
    func productWeight(productInfo: WOWProductModel) -> String {
        let format = String(format:"重量：%.1fkg",productInfo.netWeight ?? 0)
        return format
    }
}
