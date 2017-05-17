//
//  WOWPickerViewController.swift
//  swift-BaseMask
//
//  Created by 陈旭 on 2017/5/15.
//  Copyright © 2017年 陈旭. All rights reserved.
//

import UIKit
// 返回所选中行的str 以及下标
typealias SelectRowBlock =  (_ str:String, _ index: Int) -> ()

class WOWBasePickerViewController: WOWBaseMackViewController {
    var selectBlock :SelectRowBlock?
    
    var dataArr:[String] = [] { // pirker 主体数据组
        didSet{
            basePikerView.dataArr = dataArr
        }
    }
    lazy var basePikerView:BasePikerView = {[unowned self] in // 需要弹出的视图
        
        let v = BasePikerView()
        v.frame = CGRect.init(x: 0, y: MGScreenHeight - 250, width: MGScreenWidth, height: 250)
        v.contentView.sureButton.addTarget(self, action:#selector(surePicker), for:.touchUpInside)
        v.contentView.cancelButton.addTarget(self, action: #selector(dismissBtn), for: .touchUpInside)
        return v
        
    }()

    func showPicker(arr:[String],index:Int = 0)  {
        dataArr = arr
        basePikerView.contentView.pickerView.selectRow(index, inComponent: 0, animated: true)
    }
    
    func surePicker()  { // 点击确定
        
        let row = basePikerView.contentView.pickerView.selectedRow(inComponent: 0)
        let str = dataArr[row]
        
        if let block = selectBlock {
            
            block(str,row)
            
        }
        
        dismissBtn()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.containsView = self.basePikerView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

class BasePikerView: UIView,UIPickerViewDataSource, UIPickerViewDelegate { // 之所以包装一层，是为了兼容之前的 弹出方式
    var dataArr:[String] = [] {
        didSet{
            contentView.pickerView.reloadAllComponents()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        initFromXIB()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        initFromXIB()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let str = dataArr[row]
        
        return str
        
    }
    
    func initFromXIB() {
        
        contentView.frame = self.bounds
        contentView.pickerView.delegate = self
        
        self.addSubview(contentView)
        
    }
    
    lazy var contentView:WOWPickerView = {[unowned self] in
        
        let v = Bundle.main.loadNibNamed(String(describing: WOWPickerView.self), owner: self, options: nil)?.last as! WOWPickerView
        
        return v
        
    }()
}

