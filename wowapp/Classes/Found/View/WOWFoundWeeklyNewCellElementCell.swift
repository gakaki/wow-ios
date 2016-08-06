

import UIKit
import SnapKit
import YYImage

class WOWFoundWeeklyNewCellElementCell: UICollectionViewCell {
    
    class var itemWidth:CGFloat{
        get{
            return (MGScreenWidth - 1) / 3.5
        }
    }
    
    var pictureImageView: UIImageView!
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor     = UIColor.whiteColor()
        
        pictureImageView    = UIImageView()
        label               = UILabel()
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        
        self.addSubview(pictureImageView)
        
        
        pictureImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSizeMake(30, 30))
            make.center.equalTo(self).offset(UIEdgeInsets.init(top: -20, left: 5, bottom: 35, right: 5))
        }
        
        label.snp_makeConstraints { (make) -> Void in
            
            make.size.equalTo(CGSizeMake(pictureImageView.size.width, 20))
            make.top.equalTo(pictureImageView.snp_top).offset(5)
            make.left.equalTo(pictureImageView.snp_left)
            make.right.equalTo(pictureImageView.snp_right)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
