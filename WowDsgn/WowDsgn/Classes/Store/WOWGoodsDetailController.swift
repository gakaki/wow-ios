//
//  WOWGoodsDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWGoodsDetailController: WOWBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        
    }
    
    @IBAction func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}
