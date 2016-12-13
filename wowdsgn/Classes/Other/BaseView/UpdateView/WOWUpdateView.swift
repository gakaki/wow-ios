//
//  WOWUpdateView.swift
//  AlterViewController
//
//  Created by 陈旭 on 2016/12/8.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
protocol UpdateHeightDelegate:class {
    
    func updateHeight(height:CGFloat)
    
    func actionBlcok()
    
}
class WOWUpdateView: UIView,UITableViewDelegate,UITableViewDataSource{
    
    var updateContent = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    weak var delegate:UpdateHeightDelegate?
    
    @IBOutlet weak var heightAllLayout: NSLayoutConstraint!
    
    override func layoutSubviews() {
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
       heightAllLayout.constant = self.tableView.contentSize.height
        if let del = delegate {
            del.updateHeight(height: self.tableView.contentSize.height)
        }
//       print(self.tableView.contentSize.height)
    }
    override func awakeFromNib() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UpdateCell")
        self.tableView.rowHeight          = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let identify:String = "UpdateCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: identify,for: indexPath) as UITableViewCell
        
        cell.textLabel?.text            = jointImgStr(imgArray: updateContent)
        cell.textLabel?.font            = UIFont.systemFont(ofSize: 13)
        cell.textLabel?.numberOfLines   = 0
        cell.textLabel?.textColor       = UIColor.red
        cell.selectionStyle             = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return updateHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return updateFooterView
    }
    
    lazy var updateHeaderView: UIView = {
        let view = Bundle.loadResourceName(String(describing: WOWUpdateHeader.self)) as! WOWUpdateHeader
        return view
    }()
    lazy var updateFooterView: UIView = {
        let view = Bundle.loadResourceName(String(describing: WOWUpdateFooter.self)) as! WOWUpdateFooter
        
        view.updateBtn.addTarget(self, action: #selector(WOWUpdateView.clickAction), for: .touchUpInside)
        view.cancleBtn.addTarget(self, action:  #selector(WOWUpdateView.clickAction), for:.touchUpInside)
        return view
        
    }()
    func clickAction(_ sender:UIButton)  {
      
        switch sender.tag {
        case 0:
            print("点击取消")
        case 1:
            print("点击更新")
        default:break
        }
        if let del = delegate{
            del.actionBlcok()
        }
    }
    func updateAction()  {
        
    }
    func jointImgStr(imgArray:[String]) -> String {
        var imgStr = ""
        for str in imgArray.enumerated(){
            if str.offset == 0 {
                imgStr = str.element
            }else {
                imgStr = imgStr + "\n" + str.element
            }
            
            
        }
        return imgStr
        
    }

}
