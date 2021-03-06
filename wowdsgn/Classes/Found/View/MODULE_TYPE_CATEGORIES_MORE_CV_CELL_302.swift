import UIKit
//302 二级分类

protocol MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate:class{
    func MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(_ m:WowModulePageItemVO?)
}

class MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell:UICollectionViewCell{
    
    let color_bg       = UIColor.init(hexString: "f5f5f5")
    let color_text     = UIColor.init(hexString: "808080")
    let color_line     = UIColor.init(hexString: "CCCCCC")
    
    var name: UILabel!
    var line:UIView!
    var name_en:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor    = color_bg

        name                    = UILabel()
        name.textAlignment      = NSTextAlignment.center
        name_en                 = UILabel()
        name_en.textAlignment   = NSTextAlignment.center
        
        line                    = UIView()
        
        
        self.addSubview(name)
        self.addSubview(line)
        self.addSubview(name_en)
        
        name.snp.makeConstraints { (make) -> Void in
            
            name.font           = UIFont.systemFont(ofSize: 11)
            name.textColor      = color_text
            name.text           = "全部分类"
            
            make.width.equalTo(60)
            make.height.equalTo(20)

            make.center.equalTo(self.snp.center).inset(UIEdgeInsetsMake(-10, 0, 0, 0))
        }
 
        line.snp.makeConstraints { (make) -> Void in
            
            line.backgroundColor = color_line
            
            make.width.equalTo(50)
            make.height.equalTo(0.5)
            make.centerX.equalTo(name.snp.centerX)
            make.top.equalTo(name.snp.bottom).offset(1)
            
        }
        
        name_en.snp.makeConstraints { (make) -> Void in
            
            name_en.font      = UIFont.systemFont(ofSize: 12)
            name_en.textColor = color_text
            name_en.text      = "MORE"
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.centerX.equalTo(line.snp.centerX)
            make.top.equalTo(line.snp.bottom).offset(1)
            
        }
        
    }
}


class MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell:UICollectionViewCell{
    
    var bg_pic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor    = UIColor(hue:0.00, saturation:0.00, brightness:0.96, alpha:1.00)
        bg_pic                  = UIImageView()
        self.addSubview(bg_pic)

        //et ratio = bg_pic.image!.size.height / bg_pic.image!.size.width
        bg_pic.snp.makeConstraints { (make) -> Void in
            //            make.size.equalTo(self)
//            make.center.equalTo(self)
//            make.width.equalTo(self)
//            make.height.equalTo(self)//.multipliedBy(ratio)
            make.left.right.top.bottom.equalTo(self)
        }
        self.bringSubview(toFront: bg_pic)
    }
    
    func setModel(_ m:WowModulePageItemVO){
        self.bg_pic.set_webimage_url(m.categoryBgImg)
    }
}

class MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302:UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    static func isNib() -> Bool { return false }
    static func cell_type() -> Int {
        return 302
    }
    var data:[WowModulePageItemVO] = [WowModulePageItemVO]()
    var cv: UICollectionView!
    weak var delegate:MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate?
    
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
    
    func setData(_ d:[WowModulePageItemVO]){
        self.data = d
        self.cv.reloadData()
    }
    
    let size_padding                          = CGFloat(15.h)
    let size_line_spacing                     = CGFloat(8.h)
    
    var heightAll                             = CGFloat(0.h)
    
    func setUI(){
        
        let size_frame_width                  = MGScreenWidth
        let layout                            = UICollectionViewFlowLayout()
        layout.scrollDirection                = .horizontal
        
        
        // 240 315 1.3125
        layout.sectionInset                   = UIEdgeInsets(top: size_padding, left: size_padding, bottom: size_padding, right: size_padding)
        let item_width                        = ( size_frame_width - size_padding * 2 - size_line_spacing * 3 ) / 4
        let item_height                       = item_width * 1.3125
        
        layout.itemSize                       = CGSize(width: item_width ,height: item_height)
        layout.minimumInteritemSpacing        = size_line_spacing
        layout.minimumLineSpacing             = size_line_spacing
        
        heightAll                             = item_height * 2 + size_padding * 2 + size_line_spacing
        let frame                             = CGRect(x: 0, y: 0, width: size_frame_width, height: heightAll)
        
        cv                                    = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.delegate                           = self
        cv.dataSource                         = self
        cv.backgroundColor                    = UIColor.red
        
        cv.register(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self))
        cv.register(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self))
        
        cv.showsVerticalScrollIndicator       = false
        cv.showsHorizontalScrollIndicator     = false
        
        self.addSubview(cv)
        DLog("\(self.heightAll)")
        cv.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.height.equalTo(strongSelf.heightAll)
                make.top.left.right.equalTo(strongSelf)
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var c  =  self.data.count  
        if  c > 6 {
            c  =  c + 1 //没办法啦最后一个是more啦
            return c
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ((indexPath as NSIndexPath).item < 7 ){
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell
            let m               = self.data[(indexPath as NSIndexPath).item]
            cell.setModel(m)
            return cell
        }else{
            let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            if (indexPath as NSIndexPath).item < 7 {
                let m = self.data[(indexPath as NSIndexPath).row]
                del.MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(m)
            }else{
                del.MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(nil) //更多
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80.w, height: 105.h)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15, 15, 15, 15)
    }

}
