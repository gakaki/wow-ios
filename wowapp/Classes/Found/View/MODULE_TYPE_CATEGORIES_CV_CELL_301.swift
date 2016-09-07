
import UIKit

class MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell:UICollectionViewCell{
    
    var bg_pic: UIImageView!
    var name: UILabel!
    var name_en:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModel(m:WowModulePageItemVO){
        bg_pic.set_webimage_url(m.categoryBgImg)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bg_pic                  = UIImageView()
        self.addSubview(bg_pic)
        bg_pic.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }
}


//301 一级分类
class MODULE_TYPE_CATEGORIES_CV_CELL_301: UITableViewCell,ModuleViewElement,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    static func isNib() -> Bool { return false }
    var heightAll:CGFloat = CGFloat.min
    
    var collectionView: UICollectionView!
    
    var data = [WowModulePageItemVO]()
    
    func setData(d:[WowModulePageItemVO]){
        self.data = d
        self.collectionView.reloadData()
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
        
//        self.backgroundColor                              = UIColor.blackColor()
        let layout                                        = UICollectionViewFlowLayout()
        layout.scrollDirection                            = .Horizontal
        
        let size_padding                                  = CGFloat(15)
        let size_line_spacing                             = CGFloat(8)
        
        layout.sectionInset                               = UIEdgeInsets(top: size_padding, left: size_padding, bottom: size_padding, right: size_padding)
        let item_width                                    = ( MGScreenWidth - size_padding * 2 - size_line_spacing * 1 ) / 2
        let item_height                                   = item_width
        
        layout.itemSize                                   = CGSize(width: item_width ,height: item_height)
        layout.minimumInteritemSpacing                    = size_line_spacing
        layout.minimumLineSpacing                         = size_line_spacing
        
        
        heightAll                                         = item_height * 2 + size_padding * 2 + size_line_spacing
        let frame                                         = CGRectMake(0, 0, MGScreenWidth, heightAll)
        
        collectionView                                    = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collectionView.delegate                           = self
        collectionView.dataSource                         = self
        collectionView.backgroundColor                    = UIColor.clearColor()
        
        collectionView.registerClass(MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self, forCellWithReuseIdentifier:String(MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell))
        
        collectionView.showsVerticalScrollIndicator       = false
        collectionView.showsHorizontalScrollIndicator     = false
        
        collectionView.reloadData()
        
        self.addSubview(collectionView)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell), forIndexPath: indexPath) as! MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell
        let m               = data[indexPath.item]
        cell.setModel(m)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        if let del = self.delegate {
        ////            del.foundCategorycellTouchInside(categories[indexPath.item])
        //        }
    }

    
}

