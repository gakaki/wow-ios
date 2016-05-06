//
//  WOWOrderCommentController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol OrderCommentDelegate : class{
    func orderCommentSuccess()
}


class WOWOrderCommentController: WOWBaseViewController {
    var orderID : String?
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var submitButton: UIButton!
    weak var delegate:OrderCommentDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButtonClick(sender: UIButton) {
        let text = textView.text
        guard !text.isEmpty else{
            WOWHud.showMsg("请输入您的评论")
            return
        }
        let uid = WOWUserManager.userID
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_SubmitComment(uid: uid, comment:text, thingid: orderID ?? "", type:"order"), successClosure: { [weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                if let del = strongSelf.delegate{
                    del.orderCommentSuccess()
                }
            }
            
        }) { (errorMsg) in
                
        }
    }
}
