
import UIKit

protocol FoundWeeklyNewCellDelegate:class{
    func cellTouchInside(m:WOWFoundProductModel)
}

//protocol CGSizeDesign {
//    init( design_width:CGFloat,design_height:CGFloat)
//}
//
//extension CGSize:CGSizeDesign{
//    
//    static var scaleX:CGFloat{
//        get {
//            if let size = UIScreen.mainScreen().currentMode?.size{
//                switch UIDevice.deviceType{
//                case .DT_iPhone4S :     return
//                case .DT_iPhone5 :      return
//                case .DT_iPhone6 :      return
//                case .DT_iPhone6_Plus : return
//
//                default : return .DT_UNKNOWN
//                }
//            }
//            return .DT_UNKNOWN
//        }
//    }
//    
//    init( design_width:CGFloat,design_height:CGFloat)
//    {
//        switch UIDevice.deviceType{
//            case .DT_iPhone5
//            
//            
//        }
//        if (  ==
////        case CGSizeMake(640 , 960 ) : return .DT_iPhone4S
////        case CGSizeMake(640 , 1136) : return .DT_iPhone5
////        case CGSizeMake(750 , 1334) : return .DT_iPhone6
////        case CGSizeMake(1242, 2208) : return .DT_iPhone6_Plus
//
//
//    }
//
//}

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
        layout.scrollDirection              = .Horizontal
        layout.sectionInset                = UIEdgeInsets(top: 3, left: 15, bottom: 15, right: 0)
        
//        let size                            = self.w / 4
//        layout.itemSize                     = CGSize(width: 100 * (MGScreenWidth / 320 ), height:100 * (MGScreenWidth / 320 ))
//        layout.itemSize                     = CGSize(width:  MGScreenWidth * 3 / 8 , height:  MGScreenWidth *  3 / 8 + 20)
//        layout.itemSize                     = CGSize(width:  MGScreenWidth * , height:  MGScreenWidth *  3 / 8 + 20)
        
        layout.minimumInteritemSpacing      = 5
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
