//
//  WOWRegistProtocolController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWRegistProtocolController: WOWBaseViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var agreeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var nextButton: UIButton!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func agreeButtonClick(sender: UIButton) {
        //FIXME:
        DLog("同意")
    }
    
    @IBAction func nextClick(sender: UIButton) {
        let vc = UIStoryboard.initialViewController("Login", identifier:String(WOWMsgCodeController)) as! WOWMsgCodeController
        vc.entrance = .RegistCode
        navigationController?.pushViewController(vc, animated: true)
    }

}
