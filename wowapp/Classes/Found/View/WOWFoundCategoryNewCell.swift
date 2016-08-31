
import UIKit

class WOWFoundCategoryNewCell:UITableViewCell{
    
    class var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 0.5) / 4
        }
    }
    
    @IBOutlet weak var label_soldout: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        desLabel.preferredMaxLayoutWidth = (UIApplication.currentViewController()?.view.w)! / CGFloat(2) - 30
    }
    
    func showData(model:WOWProductModel,indexPath:NSIndexPath) {
        pictureImageView.set_webimage_url(model.productImg ?? "")
        desLabel.text = model.productName ?? ""
        desLabel.setLineHeightAndLineBreak(1.5)
        let result = WOWCalPrice.calTotalPrice([model.sellPrice ?? 0],counts:[1])
        priceLabel.text     = result //千万不用格式化了
        
    }
    
}