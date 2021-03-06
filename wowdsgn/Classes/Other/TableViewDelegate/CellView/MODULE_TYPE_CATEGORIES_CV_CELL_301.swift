
import UIKit


protocol MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate:class{
    func MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate_CellTouchInside(_ m:WowModulePageItemVO?)
}

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
    func setLookMoreUI()  {
        self.backgroundColor = UIColor.white
        bg_pic.image = UIImage.init(named: "lookMore")
    }
    func setModel(_ m:WowModulePageItemVO){
        bg_pic.set_webimage_url(m.categoryBgImg)
    }
    func setTwoLine_Model(_ m:WOWCarouselBanners){
        bg_pic.set_webimage_url(m.bannerImgSrc)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bg_pic                  = UIImageView()
        bg_pic.contentMode =   .scaleToFill
        self.addSubview(bg_pic)
        bg_pic.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }
}


//301 一级分类 场景
class MODULE_TYPE_CATEGORIES_CV_CELL_301: UITableViewCell,ModuleViewElement,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    static func isNib() -> Bool { return false }
    static func cell_type() -> Int {
        return 301
    }
    
    var heightAll:CGFloat = CGFloat.leastNormalMagnitude
    
    var collectionView: UICollectionView!
    weak var delegate:MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate?

    var data = [WowModulePageItemVO]()
        
    func setData(_ d:[WowModulePageItemVO]){
        self.data = d
        
        collectionView.reloadData()
        self.changeUI()

    }
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
        self.changeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func changeUI(){
        
        
        var count                                         = CGFloat(self.data.count / 2)
        let mod                                           = self.data.count % 2 == 0 ? 0 : 1
        count                                             = count + CGFloat(mod)
        
        let item_width                                    = ( MGScreenWidth - size_padding * 2 - size_line_spacing * 1 ) / 2
        let item_height                                   = item_width
        self.heightAll                                    = item_height * count + size_padding * 1 + size_line_spacing * (count - 1)
        //因为top那个padding去掉额
        
        let frame                                         = CGRect(x: 0, y: 0, width: MGScreenWidth, height: heightAll)
        collectionView.frame                              = frame
        collectionView.snp.updateConstraints {[weak self] (make) in
            if let strongSelf = self {
                make.height.equalTo(strongSelf.heightAll)
            }
        }
        
    }
    
    let size_padding                                      = CGFloat(15)
    let size_line_spacing                                 = CGFloat(8)
    
    func setUI(){
        
        let layout                                        = UICollectionViewFlowLayout()
        layout.scrollDirection                            = .vertical
        
        layout.sectionInset                               = UIEdgeInsets(top: 0, left: size_padding, bottom: size_padding, right: size_padding)
        let item_width                                    = ( MGScreenWidth - size_padding * 2 - size_line_spacing * 1 ) / 2
        let item_height                                   = item_width
        
        layout.itemSize                                   = CGSize(width: item_width ,height: item_height)
        layout.minimumInteritemSpacing                    = size_line_spacing
        layout.minimumLineSpacing                         = size_line_spacing
        
        
        heightAll                                         = item_height * 2 + size_padding * 2 + size_line_spacing
        let frame                                         = CGRect(x: 0, y: 0, width: MGScreenWidth, height: heightAll)
        
        collectionView                                    = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate                           = self
        collectionView.dataSource                         = self
        collectionView.backgroundColor                    = UIColor.white
//        collectionView.autoresizingMask                   = [UIViewAutoresizing.FlexibleHeight , UIViewAutoresizing.FlexibleWidth] //其实没啥用
        collectionView.register(MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self, forCellWithReuseIdentifier:String(describing: MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self))
        collectionView.showsVerticalScrollIndicator       = false
        collectionView.showsHorizontalScrollIndicator     = false
        
        self.addSubview(collectionView)
       
        collectionView.snp.makeConstraints { [weak self](make) in
            if let strongSelf = self {
                make.height.equalTo(strongSelf.heightAll)
                make.top.bottom.left.right.equalTo(strongSelf)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell.self), for: indexPath) as! MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell
        let m               = data[(indexPath as NSIndexPath).item]
        cell.setModel(m)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            let m               = data[(indexPath as NSIndexPath).item]
            del.MODULE_TYPE_CATEGORIES_CV_CELL_301_Cell_Delegate_CellTouchInside(m)
        }
    }

    
}
