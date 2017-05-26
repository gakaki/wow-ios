
import UIKit
import WebKit



class WOWProductDetailTipsWebViewCell: UITableViewCell,UIWebViewDelegate {
    

    @IBOutlet weak var exchangeLb: UILabel!     //商品退换
    @IBOutlet weak var qualityLb: UILabel!      //商品质量
    @IBOutlet weak var taxationLb: UILabel!     //税费说明
    @IBOutlet weak var shipfeeLb: UILabel!      //配送费用
    @IBOutlet weak var deliverytimeLb: UILabel! //配送时间
    @IBOutlet weak var rangeLb: UILabel!        //发货范围
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
    }
   
    
    
    func showData(_ model:WOWProductModel?){
   
        
        if let model = model {
            
            exchangeLb.colorWithTextWithLine("商品退换：", str2: "除定制产品、特价产品外，尖叫设计所售产品均提供7天退换货服务。", str1Color: UIColor.black, lineHeight: 1.5)

            qualityLb.colorWithTextWithLine("商品质量：", str2: "尖叫设计所售商品均为原创正品，如遇商品签收后发现质量问题，请您签收后24小时内拍照取证并向客服提出反馈，尽快联系客服申请退换货。", str1Color: UIColor.black, lineHeight: 1.5)
            
            rangeLb.colorWithTextWithLine("发货范围：", str2: "全国可送（除新疆、西藏、甘肃、青海） 特殊地区（香港、台湾等地）发货与内地发货的邮费计算方式不同，您可于付款前联系客服确认。", str1Color: UIColor.black, lineHeight: 1.5)
            
            if model.isOversea ?? false {
                
                shipfeeLb.colorWithTextWithLine("配送费用：", str2: "海外购商品均包邮，入境后产生的额外配送和转运费用也由商家承担，转运后的快递信息会在订单详情更新。订单中的多件产品，可能会根据发货期的不同进行合理拆单。拆单所产生的额外配送费将由尖叫设计承担。", str1Color: UIColor.black, lineHeight: 1.5)
                
                deliverytimeLb.colorWithTextWithLine("配送时间：", str2: "客户下单后我们将在72小时内发货，海外购商品的具体到货时间依情况有所差异，最长不超过30天，我们将在您下单后第一时间与您确认。", str1Color: UIColor.black, lineHeight: 1.5)
                
                taxationLb.colorWithTextWithLine("税费说明：", str2: "如遇海关抽检产生税费时，商品产生的进口税均由商家承担。", str1Color: UIColor.black, lineHeight: 1.5)

            }else {

                shipfeeLb.colorWithTextWithLine("配送费用：", str2: "单个订单高于¥99元包邮，低于¥99元价格为15元，订单中的多件产品，可能会根据发货期的不同进行合理拆单。拆单所产生的额外配送费将由尖叫设计承担。", str1Color: UIColor.black, lineHeight: 1.5)
                
                deliverytimeLb.colorWithTextWithLine("配送时间：", str2: "客户下单后我们将在72小时内发货，特殊商品具体到货时间依情况有所差异，我们将在您下单后第一时间与您确认。", str1Color: UIColor.black, lineHeight: 1.5)
                taxationLb.text = ""
            }

  
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        }
    
    
    

    
}
