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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        self.imgPhoto.image = photo
        

        // Do any additional setup after loading the view.
    }
    func showPhoto(image :UIImage)  {
    }
    @IBAction func releaseAction(_ sender: Any) {
          VCRedirect.bingWorksDetails()
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
