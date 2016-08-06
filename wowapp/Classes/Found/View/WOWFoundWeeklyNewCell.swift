
import UIKit

protocol FoundWeeklyNewCellDelegate:class{
    func cellTouchInside(brandModel:WOWBrandListModel)
}

class WOWFoundWeeklyNewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate:FoundWeeklyNewCellDelegate?
    
    var products = [WOWFoundRecommendModel](){
        didSet{
            if ( products.count > 0 ){
                collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerClass(WOWFoundWeeklyNewCellElementCell.self, forCellWithReuseIdentifier:String(WOWFoundWeeklyNewCellElementCell))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//extension WOWFoundWeeklyNewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return products.count
//    }
    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFoundWeeklyNewCellElementCell), forIndexPath: indexPath) as! WOWFoundWeeklyNewCellElementCell
//       
//        let model = products[indexPath.item]
//        let url = NSURL(string:model.brandImageUrl ?? "")
//        cell.pictureImageView.kf_setImageWithURL(url!, placeholderImage:UIImage(named: "placeholder_product"))
//        WOWBorderColor(cell)
//        return cell
//    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake((self.w - 45)/3, (self.w - 45)/3)
//    }

//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if let del = self.delegate {
//            if showBrand {
//                del.hotBrandCellClick(brandDataArr[indexPath.row])
//            }else{
//                del.recommenProductCellClick(productArr[indexPath.row])
//            }
//        }
//    }
//}
