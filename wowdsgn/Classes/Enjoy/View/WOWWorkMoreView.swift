//
//  WOWWorkMoreView.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/4/12.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
//MARK:*****************************背景视图******************************************

class WOWWorkMoreBackView: UIView {
    //MARK:Lazy
    lazy var selectView:WOWWorkMoreView = {
        let v = Bundle.loadResourceName(String(describing: WOWWorkMoreView.self)) as! WOWWorkMoreView
        v.isUserInteractionEnabled = true
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
    
    lazy var dismissButton:UIButton = {[unowned self] in
        let b = UIButton(type: .system)
        b.backgroundColor = UIColor.clear
        b.addTarget(self, action: #selector(hideView), for:.touchUpInside)
        return b
    }()
    //MARK:Private Method
    fileprivate func setUP(){
        
        addSubview(selectView)
        selectView.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.right.bottom.equalTo(strongSelf).offset(0)
                make.height.equalTo(0)
            }
        }
        insertSubview(dismissButton, belowSubview: selectView)
        dismissButton.snp.makeConstraints {[weak self](make) in
            if let strongSelf = self{
                make.left.top.right.equalTo(strongSelf).offset(0)
                make.bottom.equalTo(strongSelf.selectView.snp.top).offset(0)
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    
    
    //MARK:Actions
    fileprivate func show() {
        
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.alpha = 1
                strongSelf.layoutIfNeeded()
            }
            
        })
    }
    
    func showView_self() {
        let model1 = WOWMoreModel(type: .edit, name: "编辑")
        let model2 = WOWMoreModel(type: .delete, name: "删除")
        let model3 = WOWMoreModel(type: .cancle, name: "取消")
        let array = [model1, model2, model3]
        selectView.moreArr = array
        selectView.snp.updateConstraints { (make) in
            make.height.equalTo(150)
        }
        show()
    }
    
    func showView_othersOne() {
        let model1 = WOWMoreModel(type: .report, name: "举报")
        let model2 = WOWMoreModel(type: .cancle, name: "取消")
        let array = [model1, model2]
        selectView.moreArr = array
        selectView.snp.updateConstraints { (make) in
            make.height.equalTo(100)
        }
        show()
    }
    
    func showView_othersTwo() {
        let model1 = WOWMoreModel(type: .rubbish, name: "垃圾信息")
        let model2 = WOWMoreModel(type: .improper, name: "内容不当")
        let model3 = WOWMoreModel(type: .cancle, name: "取消")
        let array = [model1, model2, model3]
        selectView.moreArr = array
        selectView.snp.updateConstraints { (make) in
            make.height.equalTo(150)
        }
        show()
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
    
    func hideOtherView() {
        selectView.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        self.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            if let strongSelf = self {
                strongSelf.layoutIfNeeded()
            }
            
            }, completion: {[weak self] (ret) in
                if let strongSelf = self {
                    strongSelf.showView_othersTwo()
                    
                }
        })

    }

    
    
}
protocol WOWWorkMoreViewDelegate:class {
    
    //选择分类
    func selectType(type: MoreType)
}
class WOWWorkMoreView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: WOWWorkMoreViewDelegate?
    
    var moreArr = [WOWMoreModel]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    let cellID = String(describing: WOWWorkMoreCell.self)
    
    
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.nibName(cellID), forCellReuseIdentifier:cellID)
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.white
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! WOWWorkMoreCell
        let model = moreArr[indexPath.row]
        cell.showData(model: model)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = moreArr[indexPath.row]
        if let del = delegate {
            del.selectType(type: model.type)
        }


    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

