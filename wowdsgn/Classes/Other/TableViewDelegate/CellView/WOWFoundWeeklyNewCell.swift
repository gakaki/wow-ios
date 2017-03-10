
import UIKit

protocol FoundWeeklyNewCellDelegate:class{
    func cellFoundWeeklyNewCellTouchInside(_ m:WOWProductModel)
}

//401 本周上新
class WOWFoundWeeklyNewCell: UITableViewCell,ModuleViewElement{
    
    static func isNib() -> Bool { return true }
    static func cell_type() -> Int {
        return 401
    }
    
    @IBOutlet weak var cv: UICollectionView!

    weak var delegate:FoundWeeklyNewCellDelegate?
    
    var data        = [WOWProductModel]()
    var heightAll   = CGFloat.leastNormalMagnitude
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cv.delegate                           = self
        cv.dataSource                         = self
        cv.backgroundColor                    = UIColor.white

        cv.register(UINib.nibName("WOWGoodsSmallCell"), forCellWithReuseIdentifier: "WOWGoodsSmallCell")
        cv.showsVerticalScrollIndicator       = false
        cv.showsHorizontalScrollIndicator     = false
        
        
        let layout                            = UICollectionViewFlowLayout()
        layout.scrollDirection                = .horizontal
        layout.itemSize                       = CGSizeD( 140 ,height: 200 )
        self.heightAll                        = layout.itemSize.height
        
        layout.sectionInset                   = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.minimumInteritemSpacing        = 5

        layout.minimumLineSpacing             = 1
        cv.collectionViewLayout               = layout
        
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWGoodsSmallCell", for: indexPath) as! WOWGoodsSmallCell
        //FIX 测试数据

        let model = self.data[(indexPath as NSIndexPath).item]

            cell.showData(model, indexPath: indexPath)
            cell.topView.isHidden           = true
            cell.view_rightline.isHidden    = true
            cell.bottomLine.isHidden        = true
            cell.likeBtn.isHidden           = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = self.delegate {
            del.cellFoundWeeklyNewCellTouchInside(self.data[(indexPath as NSIndexPath).row])
        }
    }
}
