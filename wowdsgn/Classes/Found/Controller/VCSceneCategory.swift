

import UIKit
import SnapKit
import YYImage

class VCSceneCategoryCell: UICollectionViewCell {
    
    dynamic var pic:        UIImageView = UIImageView()
    dynamic var name:       UILabel     = UILabel()
    dynamic var name_en:    UILabel     = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    dynamic func adjustPosition(){
        
        
    }
    dynamic func setUI(){
        
        
    }
    dynamic override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.setUI()
        self.adjustPosition()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class VCSceneCategory:UIViewController{
    
    dynamic var data1 = [1,2,3,4,5,6]
    
    dynamic func combine(){
        print("combine method")
        print(data1.count)
    }
}


