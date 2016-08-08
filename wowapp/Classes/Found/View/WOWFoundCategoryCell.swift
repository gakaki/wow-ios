import UIKit
import SnapKit
import YYImage

protocol WOWFoundCategoryCellDelegate:class{
    func foundCategorycellTouchInside(m:WOWCategoryModel)
}
//MARK: CollectionViewCell
class WOWFoundCategoryCellCollectionViewCell:UICollectionViewCell{
    
    var pictureImageView: UIImageView!
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pictureImageView    = UIImageView()
        label               = UILabel()
        label.textAlignment = NSTextAlignment.Center
        
        self.addSubview(label)
        self.addSubview(pictureImageView)
        
        pictureImageView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        label.snp_makeConstraints { (make) -> Void in
            
            label.font      = UIFont.systemFontOfSize(12)
            label.textColor = UIColor.whiteColor()
            
            make.width.equalTo(self.snp_width)
            make.height.equalTo(20)
            make.center.equalTo(self)
        }
        
        self.bringSubviewToFront(label)
    }
}

//MARK: TableViewCell
class WOWFoundCategoryCell: UITableViewCell {
    
    var cv: UICollectionView!
    
    weak var delegate:WOWFoundCategoryCellDelegate?
    
    var categories = [WOWCategoryModel](){
        didSet{
            if ( categories.count > 0 ){
                cv.reloadData()
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle,reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//MARK: CollectionView Delegate
extension WOWFoundCategoryCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setUI(){
        

        let layout                                   = UICollectionViewFlowLayout()
        layout.scrollDirection                       = .Vertical
        layout.sectionInset                          = UIEdgeInsets(top: 0, left: 2, bottom: 1, right: 2)
        layout.itemSize                              = CGSize(width: self.frame.width / 2 - CGFloat(3), height: 100 )
        layout.minimumInteritemSpacing               = 1
        layout.minimumLineSpacing                    = 1
//        layout.estimatedItemSize                     = CGSize(width: self.frame.width / 2 - CGFloat(2), height: 100 )
        
        self.cv                                      = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        
        self.cv.delegate                             = self
        self.cv.dataSource                           = self
        self.cv.backgroundColor                      = UIColor.whiteColor()
        self.cv.registerClass(WOWFoundCategoryCellCollectionViewCell.self, forCellWithReuseIdentifier:String(WOWFoundCategoryCellCollectionViewCell))
        self.cv.showsVerticalScrollIndicator         = false
        self.cv.showsHorizontalScrollIndicator       = false
        
        self.contentView.addSubview(self.cv)
        
        
        
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFoundCategoryCellCollectionViewCell), forIndexPath: indexPath) as! WOWFoundCategoryCellCollectionViewCell
        let model           = categories[indexPath.item]
        
        cell.pictureImageView.set_webimage_url( model.categoryBgImg!)
        cell.label.text     = model.categoryName!
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            del.foundCategorycellTouchInside(categories[indexPath.item])
        }
    }
}
