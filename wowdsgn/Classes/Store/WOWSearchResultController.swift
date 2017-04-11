//
//  WOWSearchResultController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/17.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol SearchResultDelegate:class{
    func searchResultSelect(_ model:WOWBrandV1Model)
}

class WOWSearchResultController: WOWBaseTableViewController {

    var resultArr = [WOWBrandV1Model]()
    var delegate  : SearchResultDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        self.edgesForExtendedLayout = UIRectEdge()
        tableView.register(UINib.nibName("WOWBaseStyleCell"), forCellReuseIdentifier:"WOWBaseStyleCell")
        tableView.keyboardDismissMode = .onDrag
    }
}


extension WOWSearchResultController{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WOWBaseStyleCell", for: indexPath) as! WOWBaseStyleCell
        let model = resultArr[(indexPath as NSIndexPath).row]
        cell.leftImageView.set_webimage_url(model.image )

        cell.centerTitleLabel!.text = model.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = resultArr[(indexPath as NSIndexPath).row]
        if let del = delegate {
            del.searchResultSelect(model)
        }
    }
}
