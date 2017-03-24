//
//  WOWSelectCategory.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/23.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
//MARK:*****************************背景视图******************************************

class WOWCategoryBackView: UIView {
    //MARK:Lazy
    lazy var payView:WOWSelectCategory = {
        let v = Bundle.loadResourceName(String(describing: WOWSelectCategory.self)) as! WOWSelectCategory
        v.isUserInteractionEnabled = true
        return v
    }()
    
    lazy var backClear:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dismissButton:UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.clear
        b.addTarget(self, action: #selector(hidePayView), for:.touchUpInside)
        return b
    }()
    //MARK:Private Method
    fileprivate func setUP(){
        self.frame = CGRect(x: 0, y: 0, width: self.w, height: self.h)
        backgroundColor = MaskColor
        self.alpha = 0
    }
    
    
    
    //MARK:Actions
    func show() {
        backClear.frame = CGRect(x: 0,y: -self.h,width: self.w,height: self.h)
        addSubview(backClear)

        backClear.addSubview(payView)
        payView.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.top.equalTo(strongSelf).offset(0)
                make.height.equalTo(MGScreenHeight*0.75)
            }
        }
        backClear.insertSubview(dismissButton, belowSubview: payView)
        dismissButton.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.bottom.right.equalTo(strongSelf).offset(0)
                make.top.equalTo(strongSelf.payView.snp.bottom).offset(0)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.backClear.y = 0
            }
            

        })
    }
    
    func closeButtonClick()  {
  
        hidePayView()
    }
    
    func hidePayView(){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.backClear.y = -strongSelf.h
                strongSelf.alpha = 0
            }
            
        }, completion: {[weak self] (ret) in
            if let strongSelf = self {
                strongSelf.removeFromSuperview()

            }
        })
    }
    
    
}

class WOWSelectCategory: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellID = String(describing: WOWRemissionNameCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configTable()
        
    }
    fileprivate func configTable(){
        tableView.estimatedRowHeight = 30
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWRemissionNameCell
        cell.productNameLabel.text = "ceshi"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed(String(describing: WOWRemissionHeaderView.self), owner: self, options: nil)?.last as! WOWRemissionHeaderView
        v.promotionLabel.text = "全部分类"
        return v
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

}

