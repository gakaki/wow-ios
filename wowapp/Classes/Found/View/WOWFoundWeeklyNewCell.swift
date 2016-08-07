
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
        collectionView.backgroundColor      = UIColor.whiteColor()
        collectionView.registerClass(WOWFoundWeeklyNewCellElementCell.self, forCellWithReuseIdentifier:String(WOWFoundWeeklyNewCellElementCell))
        collectionView.showsVerticalScrollIndicator       = false
        collectionView.showsHorizontalScrollIndicator     = false
        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .Vertical
        layout.sectionInset                 = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        layout.itemSize                     = CGSize(width: 80, height: 90)
        
        layout.minimumInteritemSpacing      = 4
        
//        layout.minimumLineSpacing           = 1
        //        layout.itemSize = CGSize(width: (UIScreen.mainScreen().bounds.size.width - 40)/3, height: ((UIScreen.mainScreen().bounds.size.width - 40)/3))
        self.collectionView.collectionViewLayout = layout

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
        
        let url             = NSURL(string:model.productImg ?? "")
        cell.pictureImageView.yy_setImageWithURL(url , placeholder: UIImage(named: "placeholder_product"))
        cell.label.text     = model.get_formted_price()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            del.cellTouchInside(self.products[indexPath.row])
        }
    }
}
