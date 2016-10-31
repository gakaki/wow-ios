//
//  MainCell.swift
//  XXPagingScrollView
//
//  Created by 陈旭 on 2016/10/18.
//  Copyright © 2016年 LJC. All rights reserved.
//

import UIKit
protocol cell_801_delegate:class {
    // 跳转专题详情代理
    func goToProcutDetailVCWith_801(_ productId: Int?)
}
class Cell_103_Product: UITableViewCell {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 801 // 今日单品倒计时
    }

    var cardCount:Int = 0
    weak var delegate : cell_801_delegate?
    var isConfigCellUI :Bool = false
    var dataSourceArray:[WOWProductModel]?{
        didSet{
            cardCount = dataSourceArray?.count ?? 0
            if isConfigCellUI == false{
                isConfigCellUI = true
                configUI(data: dataSourceArray!)
                showDateNew()
            }
           
        }
    }
    
    @IBOutlet weak var pagingScrollView: PagingScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //        configUI()
    }
    deinit {
        print("释放")
    }
    
    func countDownView() -> WOWCountDownView {
        let v = Bundle.main.loadNibNamed("WOWCountDownView", owner: self, options: nil)?.last as! WOWCountDownView
        
        return v
    }
    func singProductView() -> WOW_SingProductView {
        let v = Bundle.main.loadNibNamed("WOW_SingProductView", owner: self, options: nil)?.last as! WOW_SingProductView
        
        return v
    }
    func showDateNew()  {
        
        for i in 0..<cardCount{
          let model = dataSourceArray?[i]
            let downView = pagingScrollView.viewWithTag(i + 1000) as? WOWCountDownView
//            downView?.timeStamp = model?.timeoutSeconds ?? 0
            downView?.model = model
        }
    }
    
    func configUI(data: [WOWProductModel]) {
        let cardSize:CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 210)
   
        pagingScrollView.cardCount = CGFloat(cardCount)
        pagingScrollView.pagingWidth  =  UIScreen.main.bounds.size.width
        pagingScrollView.pagingHeight = 210
        
        for i in 0..<Int(pagingScrollView.cardCount) {
            let model = data[i]
            let v = singProductView()
            let cv = countDownView()
            
            cv.frame = (v.view_CountDown?.bounds)!
            
            cv.tag = i + 1000

            v.view_CountDown?.addSubview(cv)
            
            pagingScrollView.scrollView.addSubview(v)
            
            v.imgVieww.set_webimage_url_base(model.productImg, place_holder_name: "placeholder_product")
            v.imgVieww.isUserInteractionEnabled = true
            v.imgVieww.addTapGesture(action: {[weak self] (make) in
                if let strongSelf = self {
                if let dev = strongSelf.delegate{
                    dev.goToProcutDetailVCWith_801(model.productId)
                }
              }
            
            })
            
            if let price = model.sellPrice {
                let result = WOWCalPrice.calTotalPrice([price],counts:[1])
                 v.priceLabel.text     = result//千万不用格式化了
                 v.originalpriceLabel.setStrokeWithText("")
                if let originalPrice = model.originalprice {
                    if originalPrice > price{
                        //显示下划线
                        let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                        
                        v.originalpriceLabel.setStrokeWithText(result)
                    }
                }
            }
            v.snp.makeConstraints({ (make) in
                
                make.top.bottom.equalTo(pagingScrollView)
                make.width.equalTo(MGScreenWidth)
                make.centerX.equalTo(CGFloat(i)*cardSize.width + MGScreenWidth/2).priority(750)
    
            })
        }
        pagingScrollView.scrollView.delegate = self
        pagingScrollView.scrollView.contentSize = CGSize(width: cardSize.width*pagingScrollView.cardCount, height: cardSize.height)

    }
       override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension Cell_103_Product:UIScrollViewDelegate{
    //scrollView滚动完毕后触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //获取当前偏移量
//        let offset = scrollView.contentOffset.x
//        print(offset)
    }

}
