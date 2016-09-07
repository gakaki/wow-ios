import UIKit
//302 二级分类

protocol MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate:class{
    func MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(cid:Int)
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
        name.textAlignment      = NSTextAlignment.Center
        name_en                 = UILabel()
        name_en.textAlignment   = NSTextAlignment.Center
        
        line                    = UIView()
        
        
        self.addSubview(name)
        self.addSubview(line)
        self.addSubview(name_en)
        
        name.snp_makeConstraints { (make) -> Void in
            
            name.font           = UIFont.systemFontOfSize(11)
            name.textColor      = color_text
            name.text           = "全部分类"
            
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.center.equalTo(self.snp_center).offset(UIEdgeInsetsMake(-10, 0, 0, 0))
            
        }
        
        line.snp_makeConstraints { (make) -> Void in
            
            line.backgroundColor = color_line
            
            make.width.equalTo(50)
            make.height.equalTo(0.5)
            make.centerX.equalTo(name.centerX)
            make.top.equalTo(name.snp_bottom).offset(1)
            
        }
        
        name_en.snp_makeConstraints { (make) -> Void in
            
            name_en.font      = UIFont.systemFontOfSize(12)
            name_en.textColor = color_text
            name_en.text      = "MORE"
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.centerX.equalTo(line.centerX)
            make.top.equalTo(line.snp_bottom).offset(1)
            
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
        bg_pic.snp_makeConstraints { (make) -> Void in
            //            make.size.equalTo(self)
            make.center.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self)//.multipliedBy(ratio)
        }
        self.bringSubviewToFront(bg_pic)
    }
    
    func setModel(m:WowModulePageItemVO){
        self.bg_pic.set_webimage_url(m.categoryBgImg)
    }
 
}

class MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302:UITableViewCell,ModuleViewElement,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    static func isNib() -> Bool { return false }
    
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
    
    func setData(d:[WowModulePageItemVO]){
        self.data = d
        self.cv.reloadData()
    }
    
    let size_padding                          = CGFloat(15.h)
    let size_line_spacing                     = CGFloat(8.h)
    
    var heightAll                             = CGFloat(0.h)
    
    func setUI(){
        
        let size_frame_width                  = self.frame.width
        let layout                            = UICollectionViewFlowLayout()
        layout.scrollDirection                = .Horizontal
        
        
        // 240 315 1.3125
        layout.sectionInset                   = UIEdgeInsets(top: size_padding, left: size_padding, bottom: size_padding, right: size_padding)
        let item_width                        = ( size_frame_width - size_padding * 2 - size_line_spacing * 3 ) / 4
        let item_height                       = item_width * 1.3125
        
        layout.itemSize                       = CGSize(width: item_width ,height: item_height)
        layout.minimumInteritemSpacing        = size_line_spacing
        layout.minimumLineSpacing             = size_line_spacing
        
        heightAll                             = item_height * 2 + size_padding * 2 + size_line_spacing
        let frame                             = CGRectMake(0, 0, size_frame_width, heightAll)
        
        cv                                    = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.delegate                           = self
        cv.dataSource                         = self
        cv.backgroundColor                    = UIColor.clearColor()
        
        cv.registerClass(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell.self, forCellWithReuseIdentifier:String(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell))
        cv.registerClass(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell.self, forCellWithReuseIdentifier:String(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell))
        
        cv.showsVerticalScrollIndicator       = false
        cv.showsHorizontalScrollIndicator     = false
        
        self.addSubview(cv)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var c  =  self.data.count  ?? 0
        if  c > 6 {
            c  =  c + 1 //没办法啦最后一个是more啦
            return c
        }
        else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if (indexPath.item < 7 ){
            let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell), forIndexPath: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_Cell
            let m               = self.data[indexPath.item]
            cell.setModel(m)
            return cell
        }else{
            let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell), forIndexPath: indexPath) as! MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_MoreCell
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            if indexPath.item < 7 {
                let m = self.data[indexPath.row]
                del.MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(m.categoryId!)
            }else{
                del.MODULE_TYPE_CATEGORIES_MORE_CV_CELL_302_CELL_Delegate_TouchInside(0) //更多
            }
        }
    }
}