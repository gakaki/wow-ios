
import UIKit

protocol FoundWeeklyNewCellDelegate:class{
    func cellTouchInside(m:WOWFoundProductModel)
}



class WOWFoundWeeklyNewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:FoundWeeklyNewCellDelegate?
    
    var products = [WOWFoundProductModel](){
        didSet{
            if ( products.count > 0 ){
                collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor                    = UIColor.whiteColor()
        collectionView.registerClass(WOWFoundWeeklyNewCellElementCell.self, forCellWithReuseIdentifier:String(WOWFoundWeeklyNewCellElementCell))
        collectionView.showsVerticalScrollIndicator       = false
        collectionView.showsHorizontalScrollIndicator     = false
        let layout                                        = UICollectionViewFlowLayout()
        layout.scrollDirection                            = .Horizontal
        layout.sectionInset                               = UIEdgeInsets(top: 3.w, left: 0.w, bottom: 15.w, right: 0)
        
        layout.itemSize                                   = CGSizeD( 100 ,height: 120)
        
        layout.minimumInteritemSpacing                    = 1.w
        self.collectionView.collectionViewLayout          = layout

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension WOWFoundWeeklyNewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFoundWeeklyNewCellElementCell), forIndexPath: indexPath) as! WOWFoundWeeklyNewCellElementCell
        let model           = products[indexPath.item]
        
        cell.pictureImageView.set_webimage_url(model.productImg!)
        cell.label.text     = model.get_formted_sell_price()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            del.cellTouchInside(self.products[indexPath.row])
        }
    }
}
