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
    lazy var selectView:WOWSelectCategory = {
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
        self.frame = frame
        backgroundColor = MaskColor
        self.alpha = 0
        setUP()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var dismissButton:UIButton = {
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.clear
//        b.addTarget(self, action: #selector(hidePayView), for:.touchUpInside)
        return b
    }()
    //MARK:Private Method
    fileprivate func setUP(){
       
        addSubview(selectView)
        selectView.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.top.equalTo(strongSelf).offset(0)
                make.height.equalTo(0)
            }
        }
        insertSubview(dismissButton, belowSubview: selectView)
        dismissButton.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.bottom.right.equalTo(strongSelf).offset(0)
                make.top.equalTo(strongSelf.selectView.snp.bottom).offset(0)
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    
    //MARK:Actions
    func show() {

        
        selectView.snp.updateConstraints { (make) in
            make.height.equalTo(MGScreenHeight*0.6)
        }
        self.setNeedsLayout()

        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.layoutIfNeeded()
            }
            

        })
    }
    
    func closeButtonClick()  {
  
        hideView()
    }
    
    func hideView(){
        selectView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.setNeedsLayout()

        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 0
                strongSelf.layoutIfNeeded()

            }
            
        }, completion: {[weak self] (ret) in
            if let strongSelf = self {
                strongSelf.removeFromSuperview()

            }
        })
    }
    
    
}
protocol WOWSelectCategoryDelegate:class {

    //选择分类
    func selectCategory()
}
class WOWSelectCategory: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let cellID = String(describing: WOWSelectCategoryCell.self)
    weak var delegate: WOWSelectCategoryDelegate?


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
        tableView.estimatedRowHeight = 49
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWSelectCategoryCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed(String(describing: WOWAboutHeaderView.self), owner: self, options: nil)?.last as! WOWAboutHeaderView
        v.labelText.text = "全部分类"
        return v
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = delegate {
            del.selectCategory()
        }
//            UIApplication.currentViewController()?.bingWorksDetail()
        VCRedirect.bingWorksDetails()

    }
}

