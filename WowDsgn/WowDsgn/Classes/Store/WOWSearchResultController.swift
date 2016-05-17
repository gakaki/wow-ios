//
//  WOWSearchResultController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/17.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

protocol SearchResultDelegate:class{
    func searchResultSelect(model:WOWBrandModel)
}

class WOWSearchResultController: WOWBaseTableViewController {
    var resultArr = [WOWBrandModel]()
    var delegate  : SearchResultDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }
}


extension WOWSearchResultController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let model = resultArr[indexPath.row]
        cell.imageView!.kf_setImageWithURL(NSURL(string:model.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
        cell.textLabel!.text = model.name
        cell.selectionStyle = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = resultArr[indexPath.row]
        if let del = delegate {
            del.searchResultSelect(model)
        }
    }
}
