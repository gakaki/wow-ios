
import UIKit

protocol FoundWeeklyNewCellDelegate:class{
    func cellFoundWeeklyNewCellTouchInside(m:WowModulePageItemVO)
}

//401 本周上新
class WOWFoundWeeklyNewCell: UITableViewCell,ModuleViewElement{
    
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 401
    }
    @IBOutlet weak var cv: UICollectionView!
    
    weak var delegate:FoundWeeklyNewCellDelegate?
    
    var data        = [WowModulePageItemVO]()
    var heightAll   = CGFloat.min
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cv.delegate                           = self
        cv.dataSource                         = self
        cv.backgroundColor                    = UIColor.whiteColor()
        cv.registerClass(WOWFoundWeeklyNewCellElementCell.self, forCellWithReuseIdentifier:String(WOWFoundWeeklyNewCellElementCell))
        
        cv.showsVerticalScrollIndicator       = false
        cv.showsHorizontalScrollIndicator     = false
        
        
        let layout                            = UICollectionViewFlowLayout()
        layout.scrollDirection                = .Horizontal
        layout.itemSize                       = CGSizeD( 100 ,height: 150 )
        self.heightAll                        = layout.itemSize.height
        
        layout.sectionInset                   = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing        = 5

        layout.minimumLineSpacing             = 1
        cv.collectionViewLayout               = layout
        
    }
    
    func setData(d:[WowModulePageItemVO]){
        self.data = d
        self.cv.reloadData()
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
        return self.data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWFoundWeeklyNewCellElementCell), forIndexPath: indexPath) as! WOWFoundWeeklyNewCellElementCell
        let m               = self.data[indexPath.item]
        cell.setModel(m)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let del = self.delegate {
            del.cellFoundWeeklyNewCellTouchInside(self.data[indexPath.row])
        }
    }
}
