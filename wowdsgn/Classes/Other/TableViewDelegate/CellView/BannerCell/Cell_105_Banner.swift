//
//  Cell_105_Banner.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/13.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
//protocol Cell_105_BannerDelegate:class{
//    
//    func updataTableViewCellHight(section: Int)
//    func gotoVCFormLinkType_ClassBanner(model: WOWCarouselBanners)
//}
class Cell_105_Banner: UITableViewCell,ModuleViewElement {
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 105  //分类banner
    }
//    weak var delegate : Cell_105_BannerDelegate?
    var indexPathSection:Int!
    var model_Class     : WOWCarouselBanners?{// 数据源
        didSet{
            
     
            heightConstraint.constant   = WOWArrayAddStr.get_img_sizeNew(str: model_Class?.background ?? "", width: MGScreenWidth, defaule_size: .ThreeToOne)

            
        }
        
    }
    var MainDataArr     = [WOWHomeModle]()
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        imgBanner.addTapGesture(action: {[weak self] (sender) in// 点击banner图片处理事件 控制展开收起状态
//            
//            if let strongSelf = self {
//                if strongSelf.model_Class?.bannerIsOut == false {
//                    
//                    strongSelf.model_Class?.bannerIsOut = true
//                    
//                }else{
//                    
//                    strongSelf.model_Class?.bannerIsOut = false
//                    
//                    
//                }
//                if let del = strongSelf.delegate {
//                    del.updataTableViewCellHight(section: strongSelf.indexPathSection)
//                }
////                                 for a in strongSelf.MainDataArr.enumerated() {
////                                        let type = a.element.moduleType ?? 0
////                                        let id   = a.element.moduleContent?.id ?? 0
////                                        if type == 105 {
////                                            if id != strongSelf.model_Class?.id {
////                                                a.element.moduleContent?.bannerIsOut = false
////                                            }
////                                        }
////                                 }
//
//                
//            }
//            
//            
//            
//        })

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
