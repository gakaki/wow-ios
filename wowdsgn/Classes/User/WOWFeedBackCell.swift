//
//  WOWFeedBackCell.swift
//  TestDemo
//
//  Created by 陈旭 on 2016/12/21.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
class SelectBtn: UIButton {
    override func awakeFromNib() {
        
        setUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func setUI(){
        
        self.setImage(UIImage(named: "unselectBig"), for: .normal)
        self.setImage(UIImage(named: "selectBig"), for: .selected)
        
    }
    
}
// type 1:产品建议 2：功能异常 3：其他
typealias ClooseTypeWithFeedBack = (_ type:Int?)->()

class WOWFeedBackCell: UITableViewCell {

    @IBOutlet weak var btnElse: SelectBtn!
    @IBOutlet weak var btnError: SelectBtn!
    @IBOutlet weak var btnSuggest: SelectBtn!
    var clooseType     : ClooseTypeWithFeedBack?
    
//    var clooseType  :Int = 1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnElse.addTarget(self, action: #selector(clickBtnForFeedBack(_:)), for: UIControlEvents.touchUpInside)
        btnError.addTarget(self, action: #selector(clickBtnForFeedBack(_:)), for: UIControlEvents.touchUpInside)
        btnSuggest.addTarget(self, action: #selector(clickBtnForFeedBack(_:)), for: UIControlEvents.touchUpInside)

        
    }
    
    func clickBtnForFeedBack(_ sender: UIButton)  {
        var cloose : Int?
        switch sender.tag {
        case 0:
            btnSuggest.isSelected       = true
            btnError.isSelected         = false
            btnElse.isSelected          = false
            cloose = 1
        case 1:
            btnSuggest.isSelected       = false
            btnError.isSelected         = true
            btnElse.isSelected          = false
             cloose = 2
        case 2:
            btnSuggest.isSelected       = false
            btnError.isSelected         = false
            btnElse.isSelected          = true
             cloose = 3
            
        default:break
            
        }
//        type(clooseType)
        if let clooseType = clooseType {
            clooseType(cloose)
        }
      
//        clooseType!(type)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
