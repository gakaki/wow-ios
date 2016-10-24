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
//        didSet{
//      
//             showDateNew()
//        }
//    }
    var isConfigCellUI :Bool = false
    var dataSourceArray:[WOWProductModel]?{
        didSet{
            cardCount = dataSourceArray?.count ?? 0
            if isConfigCellUI == false{
                isConfigCellUI = true
                 configUI()
                showDateNew()
            }
           
        }
    }
    @IBOutlet weak var pagingScrollView: PagingScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        configUI()
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
            downView?.timeStamp = model?.timeoutSeconds ?? 0
            
        }
    }
    func configUI() {
        let cardSize:CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 210)
   
        pagingScrollView.cardCount = CGFloat(cardCount)
       pagingScrollView.pagingWidth  =  UIScreen.main.bounds.size.width
        pagingScrollView.pagingHeight = 210
        
        for i in 0..<Int(pagingScrollView.cardCount) {
            let v = singProductView()
            let cv = countDownView()
            cv.frame = (v.view_CountDown?.bounds)!
//            cv.timeStamp = 10 + i
            cv.tag = i + 1000
            cv.timerOverEvent = {
                print("停止")
            }
            switch i {
            case 0:
                v.imgVieww.backgroundColor = UIColor.red
            case 1:
                v.imgVieww.backgroundColor = UIColor.blue
            case 2:
                v.imgVieww.backgroundColor = UIColor.black
            default:
                break
            }
            v.view_CountDown?.addSubview(cv)
            pagingScrollView.scrollView.addSubview(v)
            
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
