//
//  WOWRegistProtocolController.swift
//  Wow
//
//  Created by 小黑 on 16/4/10.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

typealias ActionClosure = () -> ()

class WOWRegistProtocolController: WOWBaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var agreeButton: UIButton!
    var agreeAction:ActionClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "尖叫用户使用协议"
        // Do any additional setup after loading the view.
    }

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
        if let action = self.agreeAction {
            action()
        }
        navigationController?.popViewControllerAnimated(true)
    }
    

}
