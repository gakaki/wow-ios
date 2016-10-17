
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
    func sureBuyClick(_ product: WOWProductInfoModel?)
    //确定加车
    func sureAddCarClick(_ product: WOWProductInfoModel?)
  
}


class WOWGoodsBuyView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, ProductSpecFootViewDelegate{
    @IBOutlet weak var perPriceLabel: UILabel!          //商品价格
    @IBOutlet weak var sizeTextLabel: UILabel!          //商品尺寸
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
    //未选择颜色
    var selectColor = true
    //未选择规格
    var selectSpec = true
    
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
            
            nameLabel.text = p.productName
            perPriceLabel.text = WOWBuyCarMananger.sharedBuyCar.defaultPrice
            goodsImageView.borderColor(0.5, borderColor: MGRgb(234, g: 234, b: 234))
            if let img = WOWBuyCarMananger.sharedBuyCar.defaultImg {
//                goodsImageView.kf_setImageWithURL(NSURL(string: img)!, placeholderImage:UIImage(named: "placeholder_product"))
                goodsImageView.set_webimage_url(img)

            }
            
            //通过颜色查找规格的数组
            if let array = p.colorSpecVoList {
                colorSpecArr = array
            }
            //通过规格查找颜色的数组
            if let array = p.specColorVoList{
                specColorArr = array
            }
            
            //得到颜色的数组，并给每种颜色对应一个bool值，方便记录哪个颜色有库存
            if let array = p.colorDisplayNameList {
                for color in array {
                    let colorModel = WOWColorNameModel(colorDisplayName: color, isSelect: true)
                    colorArr.append(colorModel)
                    
                    if array.count == 1 {
                        colorIndex = 0
                        selectColorIndex()
                    }
                }
            }
            //得到规格的数组，同样给每个规格对应一个bool值，方便记录哪个规格有库存
            if let array = p.specNameList {
                for spec in array {
                    let specModel = WOWSpecNameModel(specName: spec, isSelect: true)
                    specArr.append(specModel)
                    
                    if array.count == 1 {
                        specIndex = 0
                        selectSpecIndex()
                    }                    
                }
            }
           

            collectionView.reloadData()
//            showResult(skuCount)
            /**
             *  如果规格和颜色都是一个的话，默认选中第一个
             */
            if colorArr.count == 1 && specArr.count == 1 {
                for array in colorSpecArr{
                    if array.colorDisplayName == colorArr[0].colorDisplayName{
                        color_SpecArr = array.specMapVoList
                    }
                }
                //去产品的信息
                getProductInfo()
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                
                if let del = self.delegate {
                    self.productInfo?.productQty = self.skuCount
                    
                    del.sureAddCarClick(self.productInfo)
                    
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

    /**
     加入购物车
     
     */
    @IBAction func addCarButtonClick(_ sender: UIButton) {
        if !validateMethods(){
            return
        }

        startAnimationWithRect(goodsImageView.frame, ImageView: goodsImageView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64( 0.8 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            
            if let del = self.delegate {
                self.productInfo?.productQty = self.skuCount
                
                del.sureAddCarClick(self.productInfo)
                    
            }
        })
        
    }
    /**
     立即支付
    
     */
    @IBAction func payButtonClick(_ sender: UIButton) {
        if !validateMethods(){
            return
        }
        
        if let del = delegate {
            self.productInfo?.productQty = skuCount
            del.sureBuyClick(productInfo)
            
        }
    }
//    /**
//     显示商品数量
//     
//     - parameter count: 传入数量
//     */
//    fileprivate func showResult(_ count:Int){
//        if count <= 1 {
//            subButton.isEnabled = false
//            subButton.setTitleColor(MGRgb(204, g: 204, b: 204), for: UIControlState.normal)
//        }else {
//            subButton.isEnabled = true
//            subButton.setTitleColor(UIColor.black, for: UIControlState())
//        }
//        self.countTextField.text = "\(count)"
//    }
    
    //MARK: - validate Methods
    fileprivate func validateMethods() -> Bool{
        selectSpec = true
        selectColor = true
        if colorIndex < 0 && specIndex < 0 {
            selectSpec = false
            selectColor = false
            WOWHud.showMsg("请选择产品颜色与规格")
            collectionView.reloadData()
            return false
        }
        guard colorIndex >= 0 else {
            selectColor = false
            WOWHud.showMsg("请选择产品颜色")
            collectionView.reloadData()
            return false
        }
        guard specIndex >= 0 else {
            selectSpec = false
            WOWHud.showMsg("请选择产品规格")
            collectionView.reloadData()
            return false
        }
        guard skuCount > 0 else {
            WOWHud.showMsg("所选产品无库存")
            collectionView.reloadData()
            return false
        }

        return true
    }


    
    
//MARK: - UICollectionView Delegate/Datasource Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WOWSearchCell
        if indexPath.section == 0 {
            let item = colorArr[(indexPath as NSIndexPath).row]
            cell.titleLabel.text = item.colorDisplayName
            //当选中某个cell时更改某个cell的颜色
            if (indexPath as NSIndexPath).row == colorIndex {
                updateCellStatus(cell, selected: true)
            }else {
                updateCellStatus(cell, selected: false)
            }
            
            //当选择产品规格的时候才会进到这个数组,通过判断所对应颜色的bool值来判断是否可选中
            if specIndex >= 0 {
                let str = colorArr[(indexPath as NSIndexPath).row]
                //不可选中状态
                if !str.isSelect {
                    cell.titleLabel.textColor = MGRgb(204, g: 204, b: 204)
                    cell.titleLabel.backgroundColor = MGRgb(245, g: 245, b: 245)
                    cell.isUserInteractionEnabled = false
                }
            }
            
            
            return cell

        }else {
            let item = specArr[(indexPath as NSIndexPath).row]
            cell.titleLabel.text = item.specName
            
            //当选中某个cell时更改某个cell的颜色
            if (indexPath as NSIndexPath).row == specIndex {
                updateCellStatus(cell, selected: true)
            }else {
                updateCellStatus(cell, selected: false)
            }
            
            //当选择产品颜色的时候才会进到这个数组,通过判断所对应规格的bool值来判断是否可选中
            if colorIndex >= 0 {
                let str = specArr[(indexPath as NSIndexPath).row]
                //不可选中状态
                if !str.isSelect {
                    cell.titleLabel.textColor = MGRgb(204, g: 204, b: 204)
                    cell.titleLabel.backgroundColor = MGRgb(245, g: 245, b: 245)
                    cell.isUserInteractionEnabled = false
                }
                
            }
            
            
            return cell

        }

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return colorArr.count

        }else {
            return specArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /**
         *  选中颜色规格视图
         */
        if indexPath.section == 0 {
            
            if colorIndex == (indexPath as NSIndexPath).row {
                //取消选中时恢复有库存状态
                productStock(true)
                colorIndex = -1
                //取消选中欧时恢复默认图片
                if let img = WOWBuyCarMananger.sharedBuyCar.defaultImg {
                    //                goodsImageView.kf_setImageWithURL(NSURL(string: img)!, placeholderImage:UIImage(named: "placeholder_product"))
                    goodsImageView.set_webimage_url(img)
                    
                }

                for selectSpec in specArr {
                    selectSpec.isSelect = true
                }
                
                self.collectionView.reloadData()
                return
            }
            //记录每次点击的cell下标，以便确定选择的商品规格颜色
            colorIndex = (indexPath as NSIndexPath).row
            
            selectColorIndex()
            
        }else {
            if specIndex == (indexPath as NSIndexPath).row {
                //取消选中时恢复有库存状态
                productStock(true)
                specIndex = -1
               
                for selectColor in colorArr {
                    selectColor.isSelect = true
                }
                self.collectionView.reloadData()
                return
            }
            //记录每次点击的cell下标，以便确定选择的商品规格颜色
            specIndex = (indexPath as NSIndexPath).row
            selectSpecIndex()
          
        }
        //获取产品信息
        getProductInfo()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView:UICollectionReusableView?
        //是每组的头
        if (kind == UICollectionElementKindSectionHeader){
            
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWProductSpecReusableView", for: indexPath as IndexPath) as? WOWProductSpecReusableView
            if indexPath.section == 0 {
                searchReusable?.specLabel.text = "颜色"
                searchReusable?.warnImg.isHidden = selectColor
                

            }else {
                searchReusable?.specLabel.text = "规格"
                searchReusable?.warnImg.isHidden = selectSpec
               
            }
            
            
            reusableView = searchReusable!
        }
        if (kind == UICollectionElementKindSectionFooter){
            if indexPath.section == 1 {
                let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "WOWProductSpecFootView", for: indexPath as IndexPath) as? WOWProductSpecFootView
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
        if section == 0 {
            return CGSize(width: MGScreenWidth, height: 0)
        }else {
            return CGSize(width: MGScreenWidth, height: 82)
        }
        
    }
    //MARK - UICollectionViewDelegateFlowLayout  itme的大小
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let text = colorArr[(indexPath as NSIndexPath).row].colorDisplayName
            let size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil).size
            return CGSize(width: size.width+32, height: 35)
        }else {
            let text = specArr[(indexPath as NSIndexPath).row].specName
            let size = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 35), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil).size
            return CGSize(width: size.width+32, height: 35)
        }
      
        
        
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
            if colorIndex >= 0 && specIndex >= 0 {
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

    //如果颜色和规格都选中的话就拿出这个产品的信息
    func getProductInfo() {
        //如果颜色和规格都选中的话就拿出这个产品的信息
        if colorIndex >= 0 && specIndex >= 0 {
            if let color_SpecArr = self.color_SpecArr {
                for product in color_SpecArr {
                    if product.specName == self.specArr[self.specIndex].specName {
                        self.productInfo = product.subProductInfo
                        let result = WOWCalPrice.calTotalPrice([self.productInfo?.sellPrice ?? 0],counts:[1])
                        perPriceLabel.text = result
                        
                        //如果产品有库存的话就显示1.如果没有库存的话就显示0
                        if self.productInfo?.hasStock ?? false {
                            productStock(true)
                            
                        }else {
                            productStock(false)
                           
                        }
                    }
                }
            }
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
            showStock(true)
            
            sureButton.setBackgroundColor(MGRgb(32, g: 32, b: 32), forState: .normal)

            
        }else {
            skuCount = 0
           
            
            sureButton.setBackgroundColor(MGRgb(204, g: 204, b: 204), forState: .disabled)
            
        }
        collectionView.reloadData()
    }
    //按钮是否可点击
    
    func showStock(_ hasStock: Bool) -> Void {
//        addButton.isEnabled = hasStock
//        subButton.isEnabled = hasStock
//        sureButton.isEnabled = hasStock

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

}
//MARK: - 筛选数组
extension WOWGoodsBuyView {
    
    /**
     选中某个颜色时筛选出对应规格数组
     */
    func selectColorIndex()  {
        /**
         *  遍历循环通过颜色对应规格的数组，如果数组中某个对象的颜色跟选中的颜色一样，则获取对应的产品规格列表
         *  其中包括是否可点击，是否有库存等
         */
        for array in colorSpecArr{
            if array.colorDisplayName == colorArr[colorIndex].colorDisplayName{
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
        
        //根据选中的颜色改变产品图片
        if color_SpecArr?.count > 0 {
            let img = color_SpecArr![0].subProductInfo?.productColorImg
            if let img = img {
                //                    goodsImageView.kf_setImageWithURL(NSURL(string: img)!, placeholderImage:UIImage(named: "placeholder_product"))
                goodsImageView.set_webimage_url(img)
            }
        }
        
        
    }
    
    /**
     选中某个规格筛选出对应颜色数组
     */
    func selectSpecIndex() {
        /**
         *  遍历循环通过规格对应颜色的数组，如果数组中某个对象的规格跟选中的规格一样，则获取对应的产品颜色列表
         *  其中包括是否可点击，是否有库存等
         */
        for array in specColorArr{
            if array.specName == specArr[specIndex].specName{
                spec_ColorArr = array.colorMapVoList
            }
        }
        
        //遍历把每个颜色的bool值设为false初始值，防止与上次选择的冲突
        for color in colorArr {
            color.isSelect = false
        }
        
        //通过循环遍历两个数组来筛选出所选择规格对应的颜色
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
        
        
//        //根据选中的规格改变产品尺寸
//        if spec_ColorArr?.count > 0 {
//            let sizeText = spec_ColorArr![0].subProductInfo?.sizeText
//            if let sizeText = sizeText {
//                //                    goodsImageView.kf_setImageWithURL(NSURL(string: img)!, placeholderImage:UIImage(named: "placeholder_product"))
//                sizeTextLabel.text = sizeText
//            }
//        }
    }

}


