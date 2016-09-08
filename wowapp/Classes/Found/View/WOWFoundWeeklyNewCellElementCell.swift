
import UIKit
import SnapKit
import YYImage

class WOWFoundWeeklyNewCellElementCell: UICollectionViewCell {
    
    var pictureImageView: UIImageView!
    var label_price: UILabel!
    var label_name:UILabel!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setModel(m:WowModulePageItemVO){
            pictureImageView.set_webimage_url(m.productImg!)
            label_name.text      = m.productName
            label_price.text     = m.get_formted_sell_price()
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = UIColor.whiteColor()
        
        pictureImageView    = UIImageView()
        label_price         = UILabel()
        label_name          = UILabel()


        self.addSubview(pictureImageView)
        self.addSubview(label_name)
        self.addSubview(label_price)
        
        pictureImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeD( 100 , height: 100))
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width)
        }
        
        label_name.snp_makeConstraints { (make) -> Void in

            label_name.font             = UIFont.systemFontOfSize(12)
            label_name.textColor        = UIColor.init(hexString:"808080")
            label_name.textAlignment    = NSTextAlignment.Center
            
            make.width.equalTo(self.snp_width)
            make.height.equalTo(15.h)
            make.top.equalTo(pictureImageView.snp_bottom).offset(UIEdgeInsets.init(top: 0.w, left: 0, bottom: 0, right: 0))
            
        }

        label_price.snp_makeConstraints { (make) -> Void in

            label_price.font            = UIFont.systemFontOfSize(12)
            label_price.textColor       = UIColor.blackColor()
            label_price.textAlignment   = NSTextAlignment.Center

            make.width.equalTo(self.snp_width)
            make.height.equalTo(15.h)
            make.top.equalTo(label_name.snp_bottom).offset(UIEdgeInsets.init(top: 0, left: 0, bottom: 6, right: 0))

        }
    }
    
   
    
}
