//
//  WOWBurCarEditCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol CarEditCellDelegate:class{
    func carEditCellAction(model:WOWBuyCarModel,cell:WOWBurCarEditCell)
    func carCountChange(model:WOWBuyCarModel,cell:WOWBurCarEditCell)
}


class WOWBurCarEditCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCountButton: UIButton!
    
    @IBOutlet weak var typeBackView: UIView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    var model:WOWBuyCarModel!
    
    weak var delegate:CarEditCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        typeBackView.borderRadius(16)
        typeBackView.addAction {[weak self] in
            if let strongSelf = self{
                if let del = strongSelf.delegate{ //选择规格吧
                    del.carEditCellAction(strongSelf.model,cell:strongSelf)
                }
                
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.selected = selected
        
    }

    @IBAction func countButtonClick(sender: UIButton) {
        if sender.tag == 1001{
            model.skuProductCount -= 1
            let count = model.skuProductCount ?? 1
            model.skuProductCount = (count == 0 ? 1:count)
        }else{
            model.skuProductCount += 1
        }
        if let del = self.delegate {
            del.carCountChange(self.model,cell:self)
        }
    }
    
    
    func showData(m:WOWBuyCarModel?) {
        guard let model = m else{
            return
        }
        self.model = model
        goodsImageView.kf_setImageWithURL(NSURL(string:model.skuProductImageUrl ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        nameLabel.text = model.skuProductName
        typeLabel.text = model.skuName
        countTextField.text = "\(model.skuProductCount)"
    }
    
    
    
}
