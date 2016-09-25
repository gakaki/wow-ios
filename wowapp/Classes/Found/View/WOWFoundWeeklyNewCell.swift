
import UIKit

protocol FoundWeeklyNewCellDelegate:class{
    func cellFoundWeeklyNewCellTouchInside(_ m:WowModulePageItemVO)
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
    var heightAll   = CGFloat.leastNormalMagnitude
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cv.delegate                           = self
        cv.dataSource                         = self
        cv.backgroundColor                    = UIColor.white
        cv.register(WOWFoundWeeklyNewCellElementCell.self, forCellWithReuseIdentifier:String(describing: WOWFoundWeeklyNewCellElementCell()))
        
        cv.showsVerticalScrollIndicator       = false
        cv.showsHorizontalScrollIndicator     = false
        
        
        let layout                            = UICollectionViewFlowLayout()
        layout.scrollDirection                = .horizontal
        layout.itemSize                       = CGSizeD( 100 ,height: 150 )
        self.heightAll                        = layout.itemSize.height
        
        layout.sectionInset                   = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing        = 5

        layout.minimumLineSpacing             = 1
        cv.collectionViewLayout               = layout
        
    }
    
    func setData(_ d:[WowModulePageItemVO]){
        self.data = d
        self.cv.reloadData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension WOWFoundWeeklyNewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWFoundWeeklyNewCellElementCell()), for: indexPath) as! WOWFoundWeeklyNewCellElementCell
        let m               = self.data[(indexPath as NSIndexPath).item]
        cell.setModel(m)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            del.cellFoundWeeklyNewCellTouchInside(self.data[(indexPath as NSIndexPath).row])
        }
    }
}
