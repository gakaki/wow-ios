//
//  WOWRegistInfoSecondController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWRegistInfoSecondController: WOWBaseTableViewController {
    var fromUserCenter:Bool = false
    var sex = "男"
    @IBOutlet weak var manButton: UIButton!
    @IBOutlet weak var womanButton: UIButton!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var starTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        configTable()
        configNav()
    }
    
    private func configNav(){
        makeCustomerNavigationItem("跳过", left: false) {[weak self] in
            if let strongSelf = self{
                strongSelf.dismissViewControllerAnimated(true, completion: nil)
                if strongSelf.fromUserCenter{
                    UIApplication.appTabBarController.selectedIndex = 0
                }
            }
        }
    }
    
    private func configTable(){
        let nextView = NSBundle.mainBundle().loadNibNamed(String(WOWRegistInfoSureView), owner: self, options: nil).last as! WOWRegistInfoSureView
        nextView.sureButton.addTarget(self, action: #selector(sure), forControlEvents: .TouchUpInside)
        nextView.sureButton.setTitle("完成", forState: .Normal)
        nextView.frame = CGRectMake(0,0, self.view.w, 200)
        tableView.tableFooterView = nextView
    }
    
    
//MARK:Actions
    func sure() {
        dismissViewControllerAnimated(true, completion: nil)
        if fromUserCenter{
            UIApplication.appTabBarController.selectedIndex = 0
        }
    }
    
    @IBAction func sexClick(sender: UIButton) {
        manButton.selected = (sender == manButton)
        womanButton.selected = (sender == womanButton)
        if sender.tag == 1001 { //男
            sex = "男"
        }else{ //女
            sex = "女"
        }
    }
    
}
