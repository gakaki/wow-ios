//
//  WOWSearchBrandView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/1/16.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWSearchBrandView: UIView,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "WOWSearchBrandCell"
    var brandArray = [WOWBrandV1Model]()
    
    override func awakeFromNib() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight          = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        self.backgroundColor = DefaultBackColor
        self.tableView.backgroundColor = DefaultBackColor
        self.tableView.register(UINib.nibName(cellID), forCellReuseIdentifier: cellID)
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWSearchBrandCell
        cell.showData(model: brandArray[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = brandArray[indexPath.row]
        VCRedirect.toBrand(brand_id: model.id)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
