//
//  SVCloosePriceCell.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/1/10.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class SVCloosePriceCell: UITableViewCell,UITextFieldDelegate {
    @IBOutlet weak var minTextF: UITextField!
    @IBOutlet weak var maxTextF: UITextField!

    var modelPrice : PriceSectionModel!{
        didSet{
            if let min = modelPrice.minPrice {
                minTextF.text = min.toString
            }else{
                minTextF.text = ""
            }
            if let max = modelPrice.maxPrice {
                maxTextF.text = max.toString
            }else{
                maxTextF.text = ""
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        minTextF.delegate = self
        maxTextF.delegate = self
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if let priceStr = textField.text {
                
                modelPrice.minPrice = priceStr.toInt()
            }
     
        case 1:
            if let priceStr = textField.text {
                
                modelPrice.maxPrice = priceStr.toInt()
            }

        default:break
        }
    }
}
class CloosePriceCell: UITableViewCell,NHRangeSliderViewDelegate{
    
    var heightAll:CGFloat = CGFloat.leastNormalMagnitude
    
    var priceDataArray  = [Int](){
        didSet{
             sliderCustomStringView.dataArray = priceDataArray
        }
    }
    
    let sliderCustomStringView = NHRangeSliderView()
    var modelPrice : PriceSectionModel!{
        didSet{
            
            if let min = modelPrice.minPrice {
              
            }else{
                sliderCustomStringView.lowerValue = 0.0
            }
            
            if let max = modelPrice.maxPrice {
               
            }else{
                sliderCustomStringView.upperValue = 100.0
            }
        }
    }
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUI(){
        contentView.backgroundColor = GrayColorLevel5
        sliderCustomStringView.frame =  CGRect(x: 15, y:  0, width: bounds.size.width - 30, height: 6)
        sliderCustomStringView.center.y = contentView.center.y - 10
        sliderCustomStringView.trackHighlightTintColor = UIColor.init(hexString: "FFD444")!
        sliderCustomStringView.lowerValue = 0.0
        sliderCustomStringView.upperValue = 100.0

       
//        sliderCustomStringView.gapBetweenThumbs = 10
        
        sliderCustomStringView.thumbLabelStyle = .FOLLOW
        sliderCustomStringView.delegate = self
        sliderCustomStringView.sizeToFit()
        
        contentView.addSubview(sliderCustomStringView)
        
        //        sliderCustomStringView.snp.makeConstraints {[unowned self] (make) in
        //
        //            make.left.right.equalTo(15)
        //            make.top.equalTo(15)
        //            make.height.equalTo(20)
        //
        //        }
        
        
    }
    
    func sliderValueChanged(slider: NHRangeSlider?){
        
        let lowerStr = sliderCustomStringView.lowerLabel?.text ?? "0"
        let upperStr = sliderCustomStringView.upperLabel?.text ?? "0"
        
        if upperStr.contains("+") { // 判断是否为最大的字段， 为最大，则 不传“max” 这个字段
            
            modelPrice.maxPrice = nil
            
        }else{
            
            modelPrice.maxPrice = upperStr.toInt()
        
        }
        if lowerStr == "0" {// 如果处在"0" 的格度 则请求接口时不传“min”这个字段 ，以“0”来判断有风险， 产品说，最低为0
            modelPrice.minPrice = nil
        }else {
            modelPrice.minPrice = lowerStr.toInt()
        }
        
//        if (sliderCustomStringView.upperLabel?.text?.contains("+"))! {
//            sliderCustomStringView.upperLabel?.text?.remove(at: "+")
//        }
        
//        let a = Int(round((slider?.lowerValue)! / sliderCustomStringView.stepValue! ))
//        let b = Int(round((slider?.upperValue)! / sliderCustomStringView.stepValue! ))
//        
//        let a  = Int(round(sliderCustomStringView.lowerValue / (sliderCustomStringView.stepValue ?? 0.0)))
//        let b  = Int(round(sliderCustomStringView.upperValue / (sliderCustomStringView.stepValue ?? 0.0)))
//        
//        modelPrice.minPrice = priceDataArray[a]
////        sliderCustomStringView.lowerLabel?.text?.toInt()
//        
//        modelPrice.maxPrice = priceDataArray[b]
//            sliderCustomStringView.upperLabel?.text?.toInt()
    }
    
}
