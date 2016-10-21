//
//  MainCell.swift
//  XXPagingScrollView
//
//  Created by 陈旭 on 2016/10/18.
//  Copyright © 2016年 LJC. All rights reserved.
//

import UIKit

class Cell_103_Product: UITableViewCell {

    @IBOutlet weak var pagingScrollView: PagingScrollView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
           configUI()
    }
    // Class 初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
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
        for i in 0..<3{
            let downView = pagingScrollView.viewWithTag(i + 1000) as? WOWCountDownView
            downView?.timeStamp = 100 + i
            
        }
    }
    func configUI() {
        let cardSize:CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 210)
   
        pagingScrollView.cardCount = 3
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
