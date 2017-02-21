//
//  Cell_ProjectSelect_View.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/2/13.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class Cell_ProjectSelect_View: UIView {
    @IBOutlet weak var view: UIView!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    func setup() {
        _ = Bundle.main.loadNibNamed("Cell_ProjectSelect_View", owner: self, options: nil)?.last
        
        self.addSubview(self.view)
        self.view.frame = self.bounds
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
