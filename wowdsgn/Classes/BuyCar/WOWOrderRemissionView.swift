//
//  WOWOrderRemissionView.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/28.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
//MARK:*****************************背景视图******************************************

class WOWRemissionBackView: UIView {
    //MARK:Lazy
    lazy var remissionView:WOWOrderRemissionView = {
        let v = Bundle.loadResourceName(String(describing: WOWOrderRemissionView.self)) as! WOWOrderRemissionView
        v.closeBtn.addTarget(self, action: #selector(hidePayView), for:.touchUpInside)
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
        backClear.frame = CGRect(x: 0,y: self.h,width: self.w,height: self.h)
        addSubview(backClear)
        backClear.addSubview(remissionView)
        remissionView.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf.backClear).offset(0)
                make.height.equalTo(MGScreenHeight*0.5)
            }
        }
        backClear.insertSubview(dismissButton, belowSubview: remissionView)
        dismissButton.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.right.equalTo(strongSelf.backClear).offset(0)
                make.bottom.equalTo(strongSelf.remissionView.snp.top).offset(0)
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.backClear.y = 0
        })
    }
    
    
    func hidePayView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.backClear.y = self.h + 10
            self.alpha = 0
        }, completion: { (ret) in
            self.removeFromSuperview()
        })
    }
    
    
}

class WOWOrderRemissionView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var promotionInfoArr: [WOWPromotionProductInfoModel]?
    
    let cellID = String(describing: WOWRemissionNameCell.self)

  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    deinit{
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configTable()
        
    }
    fileprivate func configTable(){
        tableView.estimatedRowHeight = 30
        tableView.rowHeight          = UITableViewAutomaticDimension
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
      
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return promotionInfoArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotionInfoArr?[section].productNames?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWRemissionNameCell
            cell.productNameLabel.text = promotionInfoArr?[indexPath.section].productNames?[indexPath.row]
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = Bundle.main.loadNibNamed(String(describing: WOWRemissionHeaderView.self), owner: self, options: nil)?.last as! WOWRemissionHeaderView
        v.promotionLabel.text = promotionInfoArr?[section].promotionName
        return v
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    

}
