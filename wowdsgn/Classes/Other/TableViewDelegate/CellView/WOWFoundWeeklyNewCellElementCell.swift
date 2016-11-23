


import UIKit
import SnapKit


class WOWFoundWeeklyNewCellElementCell: UICollectionViewCell {
    
    var pictureImageView: UIImageView!
    var label_price: UILabel!
    var label_name:UILabel!
    var label_Stock:UILabel!
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func set_sold_out_status(label: UILabel){
        label.borderRadius(28)
        label.text = "以售馨"
        label.isHidden = false
    }
    func setModel(_ m:WowModulePageItemVO){
            pictureImageView.set_webimage_url(m.productImg!)
            label_name.text      = m.productName
            label_price.text     = m.get_formted_sell_price()
        
        if m.productStock == 0 {// 以售馨展示
            set_sold_out_status(label: label_Stock)
        }else {
            label_Stock.isHidden = true
        }
        
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = UIColor.white
        
        pictureImageView    = UIImageView()
        label_price         = UILabel()
        label_name          = UILabel()
        label_Stock         = UILabel()

        self.addSubview(pictureImageView)
        self.addSubview(label_name)
        self.addSubview(label_price)
        self.addSubview(label_Stock)
        
        pictureImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeD( 100 , height: 100))
            make.top.equalTo(self)
            make.width.equalTo(self)
        }
        
        label_name.snp.makeConstraints { (make) -> Void in

            label_name.font             = UIFont.systemFont(ofSize: 12)
            label_name.textColor        = UIColor.init(hexString:"808080")
            label_name.textAlignment    = NSTextAlignment.center
            
            make.width.equalTo(self.snp.width)
            make.height.equalTo(15.h)
            make.top.equalTo(pictureImageView.snp.bottom)
        }

        label_price.snp.makeConstraints { (make) -> Void in

            label_price.font            = UIFont.systemFont(ofSize: 12)
            label_price.textColor       = UIColor.black
            label_price.textAlignment   = NSTextAlignment.center

            make.width.equalTo(self.snp.width)
            make.height.equalTo(15.h)
            make.top.equalTo(label_name.snp.bottom).offset(6)

        }
        label_Stock.snp.makeConstraints { (make) -> Void  in
            label_Stock.font            = UIFont.systemFont(ofSize: 14)
            label_Stock.textColor       = UIColor.white
            label_Stock.backgroundColor       = UIColor.black.withAlphaComponent(0.4)

            label_Stock.textAlignment   = NSTextAlignment.center
            
            make.width.height.equalTo(56)
            make.center.equalTo(self.pictureImageView)

        }
    }
    
   
    
}
