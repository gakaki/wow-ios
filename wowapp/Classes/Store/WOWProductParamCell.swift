//
//  WOWProductParamCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/6.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductParamCell: UITableViewCell {
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var firstDescLabel: UILabel!
    @IBOutlet weak var secondDescLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(params:WOWAttributeModel...){ //可变参数
        if params.count == 1 {
            setSecond(true)
            firstTitleLabel.text = params.first?.title
            firstDescLabel.text  = params.first?.value
            firstImageView.image = UIImage(named: params.first?.attriImage ?? " ")
        }else if params.count == 2{
            setSecond(false)
            firstTitleLabel.text = params.first?.title
            firstDescLabel.text  = params.first?.value
            firstImageView.image = UIImage(named: params.first?.attriImage ?? " ")
            secondTitleLabel.text = params[1].title
            secondDescLabel.text  = params[1].value
            secondImageView.image = UIImage(named: params[1].attriImage ?? " ")
        }
    }
    
    func setSecond(hide:Bool) {
        secondDescLabel.hidden  = hide
        secondImageView.hidden  = hide
        secondTitleLabel.hidden = hide
    }
    
}
