//
//  WOWOrderCommentController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/5.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWOrderCommentController: WOWBaseViewController {
    var orderID : String!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var submitButton: UIButton!
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
    }
}
