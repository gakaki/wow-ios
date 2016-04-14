//
//  WOWBurCarEditCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/14.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol CarEditCellDelegate:class{
    func carEditCellAction()
}


class WOWBurCarEditCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var goodsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subCountButton: UIButton!
    
    @IBOutlet weak var typeBackView: UIView!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    weak var delegate:CarEditCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        typeBackView.borderRadius(16)
        typeBackView.addAction {[weak self] in
            if let strongSelf = self{
                if let del = strongSelf.delegate{ //选择规格吧
                    del.carEditCellAction()
                }
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.selected = selected
        
    }

    @IBAction func countButtonClick(sender: UIButton) {
        
    }
    
    
    
    
}
