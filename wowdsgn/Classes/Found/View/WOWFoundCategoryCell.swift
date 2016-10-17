import UIKit
import SnapKit
import YYImage

protocol WOWFoundCategoryCellDelegate:class{
    func foundCategorycellTouchInside(_ m:WOWCategoryModel)
}
//MARK: CollectionViewCell
class WOWFoundCategoryCellCollectionViewCell:UICollectionViewCell{
    
    var pictureImageView: UIImageView!
    var label: UILabel!
    var overlay:UIView!
    
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
        label.textAlignment = NSTextAlignment.center
        
        
        overlay             = UIView()
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)

        
        self.addSubview(label)
        self.addSubview(pictureImageView)
        self.addSubview(overlay)

        pictureImageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
        
        overlay.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }

        label.snp.makeConstraints { (make) -> Void in
            
            label.font      = UIFont.systemScaleFontSize(14)
            label.textColor = UIColor.white
        
            make.width.equalTo(self.snp.width)
            make.height.equalTo(20)
            make.center.equalTo(self)
        }
        
        self.bringSubview(toFront: label)
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

//MARK: CollectionView Delegate
extension WOWFoundCategoryCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setUI(){
        

        let layout                                   = UICollectionViewFlowLayout()
        layout.scrollDirection                       = .vertical
        layout.sectionInset                          = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize                              = CGSize(width: self.frame.width / 2 - CGFloat(8), height: self.frame.width / 3 - 15)
        layout.minimumInteritemSpacing               = 0
        layout.minimumLineSpacing                    = 5
        
//        layout.estimatedItemSize                     = CGSize(width: self.frame.width / 2 - CGFloat(2), height: 100 )
        
        self.cv                                      = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        
        self.cv.delegate                             = self
        self.cv.dataSource                           = self
        self.cv.backgroundColor                      = UIColor.white
        self.cv.register(WOWFoundCategoryCellCollectionViewCell.self, forCellWithReuseIdentifier:String(describing: WOWFoundCategoryCellCollectionViewCell.self))
        self.cv.showsVerticalScrollIndicator         = false
        self.cv.showsHorizontalScrollIndicator       = false
        self.cv.isScrollEnabled                        = false
        self.contentView.addSubview(self.cv)
        
        
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWFoundCategoryCellCollectionViewCell.self), for: indexPath) as! WOWFoundCategoryCellCollectionViewCell
        let model           = categories[(indexPath as NSIndexPath).item]
        
        cell.pictureImageView.set_webimage_url( model.categoryBgImg!)
        cell.label.text     = model.categoryName!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            del.foundCategorycellTouchInside(categories[(indexPath as NSIndexPath).item])

//            let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFoundCategoryCellCollectionViewCell), forIndexPath: indexPath) as! WOWFoundCategoryCellCollectionViewCell
//            
//            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//                cell.label.alpha = 0.0
//                cell.overlay.alpha = 0.0
//                }, completion:  { _ in
////                    cell.overlay.removeFromSuperview()
////                    cell.label.removeFromSuperview()
//                    
//                    cell.overlay.hidden = true
//                    cell.label.hidden = true
//
//
//            })
            
            
        }
    }
}

extension UIView {
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}
