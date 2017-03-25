//
//  WOWReleaseWorksController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWReleaseWorksController: WOWBaseViewController {
    var photo : UIImage!

    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        self.imgPhoto.image = photo
        self.view.backgroundColor = UIColor.white
     
        let itemReghit = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = itemReghit

        // Do any additional setup after loading the view.
    }
    func cancelAction()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func releaseAction(_ sender: Any) {
//          VCRedirect.bingWorksDetails()
        
        let vc = UIStoryboard.initialViewController("Enjoy", identifier:String(describing: WOWWorksDetailsController.self)) as! WOWWorksDetailsController
        
        vc.photo = photo
//        pushViewController(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
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
