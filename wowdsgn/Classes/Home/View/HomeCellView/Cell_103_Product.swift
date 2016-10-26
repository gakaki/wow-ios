//
//  MainCell.swift
//  XXPagingScrollView
//
//  Created by 陈旭 on 2016/10/18.
//  Copyright © 2016年 LJC. All rights reserved.
//

import UIKit

class Cell_103_Product: UITableViewCell {
    var cardCount:Int = 0

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
            
            if let price = model.sellPrice {
                let result = WOWCalPrice.calTotalPrice([price],counts:[1])
                 v.priceLabel.text     = result//千万不用格式化了
                if let originalPrice = model.originalprice {
                    if originalPrice > price{
                        //显示下划线
                        let result = WOWCalPrice.calTotalPrice([originalPrice],counts:[1])
                        
                        v.originalpriceLabel.setStrokeWithText(result)
                    }
                }else {
                    v.originalpriceLabel.setStrokeWithText("")
                }
            }

            v.snp.makeConstraints({ (make) in
                
                make.top.bottom.equalTo(pagingScrollView)
                make.width.equalTo(MGScreenWidth)
                make.centerX.equalTo(CGFloat(i)*cardSize.width + MGScreenWidth/2).priority(750)
    
            })
        }
        pagingScrollView.scrollView.contentSize = CGSize(width: cardSize.width*pagingScrollView.cardCount, height: cardSize.height)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
