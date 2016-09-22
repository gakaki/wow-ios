//
//  WOWProductDetailDescCell.swift
//  wowapp
//
//  Created by 小黑 on 16/6/3.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWProductDetailDescCell: UITableViewCell {

    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var designerButton: UIButton!
    @IBOutlet weak var designerNameLabel: UILabel!
    @IBOutlet weak var brandContainerRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var brandBorderView: UIView!
    @IBOutlet weak var designerBorderView: UIView!
    @IBOutlet weak var brandContainerView: UIView!
    @IBOutlet weak var designerContainerView: UIView!
    
    var productModel:WOWProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        WOWBorderColor(brandBorderView)
        WOWBorderColor(designerBorderView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    @IBAction func brandClick(_ sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.brandID = productModel?.brandId 
        vc.entrance = .brandEntrance
        vc.hideNavigationBar = true
        UIApplication.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func designerClick(_ sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.designerId = productModel?.designerId
        vc.entrance = .designerEntrance
        vc.hideNavigationBar = true
        UIApplication.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showData(_ model:WOWProductModel?){
        productModel = model
        brandNameLabel.text = model?.brandCname
        brandButton.kf_setBackgroundImageWithURL(URL(string:model?.brandLogoImg ?? "")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
        guard let designerName = model?.designerName , !designerName.isEmpty else{
            designerContainerView.isHidden = true
            brandContainerRightConstraint.priority = 250;
            return
        }
        designerNameLabel.text = designerName
        designerButton.kf_setBackgroundImageWithURL(URL(string: model?.designerPhoto ?? "")!, forState: .Normal, placeholderImage:UIImage(named: "placeholder_product"))
    }
}
