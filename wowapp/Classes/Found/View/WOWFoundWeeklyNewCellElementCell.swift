

import UIKit
import SnapKit
import YYImage

class WOWFoundWeeklyNewCellElementCell: UICollectionViewCell {
    
    var pictureImageView: UIImageView!
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor     = UIColor.grayColor()
        
        pictureImageView    = UIImageView()
        label               = UILabel()
        label.textAlignment = NSTextAlignment.Center
        
        self.addSubview(label)
        self.addSubview(pictureImageView)

        
        pictureImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(100, 100))
            make.center.equalTo(self).offset(UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0))
        }
        
        label.snp_makeConstraints { (make) -> Void in
            
            label.font      = UIFont.systemFontOfSize(12)
            label.textColor = UIColor.blackColor()
            
            make.width.equalTo(self.snp_width)
            make.height.equalTo(20)
            
            make.baseline.equalTo(self.snp_baseline)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
