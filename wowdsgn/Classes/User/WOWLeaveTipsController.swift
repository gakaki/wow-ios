//
//  WOWLeaveTipsController.swift
//  wowapp
//
//  Created by 小黑 on 16/6/1.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWLeaveTipsController: WOWBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "意见反馈"
//        view.backgroundColor = UIColor.red
        cofigTableView()
    }
    func cofigTableView()  {
        
        self.tableView.backgroundColor      = GrayColorLevel5
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 410
        self.tableView.delegate             = self
        self.tableView.dataSource           = self
        self.tableView.register(UINib.nibName("WOWFeedBackCell"), forCellReuseIdentifier: "WOWFeedBackCell")
        self.tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")
        
    }
    lazy var footerView: PhoneTextView = {
        let view = PhoneTextView()
        
        return view
    }()

}
extension WOWLeaveTipsController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWFeedBackCell", for: indexPath) as! WOWFeedBackCell
            cell.selectionStyle     = .none
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell
            cell.cellType           = .FeebdBack
            cell.selectionStyle     = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 15
        case 1:
            return 78
        default:
            return 0.01
            
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return footerView
        default:
            return nil
            
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
  
}

class PhoneTextView: UIView {
    
    var tvPhone: UITextField!
    var lbLine : UILabel!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tvPhone = UITextField()
        
        lbLine  = UILabel()
        lbLine.backgroundColor = GrayColorLevel5
        
        self.addSubview(lbLine)
        self.addSubview(tvPhone)
        self.backgroundColor    = UIColor.white
//        tvPhone.placeholderText = "请写下您的联系方式"
        tvPhone.placeholder     = "请输入您的联系方式"
        tvPhone.font            = UIFont.systemFont(ofSize: 15)
//        tvPhone.backgroundColor = UIColor.w
        lbLine.snp.makeConstraints {[weak self] (make) -> Void in
            if  let strongSelf = self {
                
                
                make.width.equalTo(MGScreenWidth)
                make.height.equalTo(15)
                make.top.right.equalTo(strongSelf)
                
            }
            
        }

        tvPhone.snp.makeConstraints {[weak self] (make) -> Void in
            if  let _ = self {
                
                make.width.equalTo(MGScreenWidth)
                make.height.equalTo(63)
                make.top.equalTo(15)
                make.right.equalTo(15)
    
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

