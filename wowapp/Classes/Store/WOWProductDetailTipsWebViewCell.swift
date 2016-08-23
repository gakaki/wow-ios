
import UIKit
import WebKit

class WOWProductDetailTipsWebViewCell: UITableViewCell,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var webUrl="http://127.0.0.1:8080/product_detail_tips.html"

//      var webUrl="http://baidu.com"
    override func awakeFromNib() {
        super.awakeFromNib()
        self.webView.delegate = self

        let url = NSBundle.mainBundle().URLForResource("product_detail_tips", withExtension:"html")
        webView.loadRequest( NSURLRequest(URL: url!))
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false

    }
   
    
    @IBOutlet weak var telButton: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        telButton.addBorder(width: 1, color:UIColor.blackColor())
        //        customerButton.addBorder(width: 1, color:UIColor.blackColor())
    }
    
    @IBAction func callClick(sender: UIButton) {
        WOWTool.callPhone()
    }
    
    //    @IBAction func customerServiceClick(sender: UIButton) {
    //        DLog("在线客服")
    //    }
    
}
