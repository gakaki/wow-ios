//
//  WOWBaseMackViewController.swift
//  MaskDemo
//
//  Created by 陈旭 on 2017/5/5.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit

class WOWBaseMackViewController: UIViewController {

    @IBOutlet weak var btnDismiss: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        self.btnDismiss.addTarget(self, action: #selector(dismissBtn), for: .touchUpInside)
        //设置按钮透明度
        self.btnDismiss.alpha = 0.5
        self.btnDismiss.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) { 
              self.view.layoutIfNeeded()
        }
    }
    func dismissBtn()  {
        
     UIView.animate(withDuration: 0.25, animations: { 
        self.view.layoutIfNeeded()
     }) { (finished) in
        self.dismiss(animated: false, completion: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
