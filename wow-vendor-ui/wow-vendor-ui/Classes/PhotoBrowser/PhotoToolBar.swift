//
//  PhotoToolBar.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/9.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

///  ///  @author ZeroJ, 16-05-24 23:05:11
///
//TODO: 还未使用 (it is not useful now)
struct ToolBarStyle {
    enum ToolBarPosition {
        case up
        case down
    }
    /// 是否显示保存按钮
    var showSaveBtn = true
    /// 是否显示附加按钮
    var showExtraBtn = true
    /// toolBar位置
    var toolbarPosition = ToolBarPosition.down
    
}

class PhotoToolBar: UIView {
    typealias BtnAction = (_ btn: UIButton) -> Void
    var saveBtnOnClick: BtnAction?
    var extraBtnOnClick: BtnAction?
    
    var indexText: String = " " {
        didSet {
            indexLabel.text = indexText
        }
    }
    
    var toolBarStyle: ToolBarStyle!
    
    /// 保存图片按钮
    fileprivate lazy var saveBtn: UIButton = {
        
       let saveBtn = UIButton()
        saveBtn.setTitleColor(UIColor.white, for: UIControlState())
        saveBtn.backgroundColor = UIColor.clear
        saveBtn.setImage(UIImage(named: "feed_video_icon_download_white"), for: UIControlState())
        saveBtn.addTarget(self, action: #selector(self.saveBtnOnClick(_:)), for: .touchUpInside)
        
        saveBtn.isHidden = self.toolBarStyle.showSaveBtn
        return saveBtn
    }()
    /// 附加的按钮
    fileprivate lazy var extraBtn: UIButton = {
        let extraBtn = UIButton()
        extraBtn.setTitleColor(UIColor.white, for: UIControlState())
        extraBtn.backgroundColor = UIColor.clear
        extraBtn.setImage(UIImage(named: "more"), for: UIControlState())
        extraBtn.addTarget(self, action: #selector(self.extraBtnOnClick(_:)), for: .touchUpInside)
        extraBtn.isHidden = self.toolBarStyle.showExtraBtn

        return extraBtn
    }()
    /// 显示页码
    fileprivate lazy var indexLabel:UILabel = {
       let indexLabel = UILabel()
        indexLabel.textColor = UIColor.white
        indexLabel.backgroundColor = UIColor.clear
        indexLabel.textAlignment = NSTextAlignment.center
        indexLabel.font = UIFont.systemFont(ofSize: 16)
        return indexLabel
    }()
    
    init(frame: CGRect, toolBarStyle: ToolBarStyle) {
        super.init(frame: frame)
        self.toolBarStyle = toolBarStyle
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        addSubview(saveBtn)
        addSubview(indexLabel)
        addSubview(extraBtn)
    }
    
    func saveBtnOnClick(_ btn: UIButton) {
        saveBtnOnClick?(btn)
    }
    func extraBtnOnClick(_ btn: UIButton) {
        extraBtnOnClick?(btn)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 30.0
        let btnW: CGFloat = 60.0
        
        let saveBtnX = NSLayoutConstraint(item: saveBtn, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: margin)
        let saveBtnY = NSLayoutConstraint(item: saveBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let saveBtnW = NSLayoutConstraint(item: saveBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: btnW)
        let saveBtnH = NSLayoutConstraint(item: saveBtn, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([saveBtnX, saveBtnY, saveBtnW, saveBtnH])
        
        let extraBtnX = NSLayoutConstraint(item: extraBtn, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -margin)
        let extraBtnY = NSLayoutConstraint(item: extraBtn, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let extraBtnW = NSLayoutConstraint(item: extraBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: btnW)
        let extraBtnH = NSLayoutConstraint(item: extraBtn, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        extraBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([extraBtnX, extraBtnY, extraBtnW, extraBtnH])
        
        
        let indexLabelLeft = NSLayoutConstraint(item: indexLabel, attribute: .leading, relatedBy: .equal, toItem: saveBtn, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let indexLabelY = NSLayoutConstraint(item: indexLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let indexLabelRight = NSLayoutConstraint(item: indexLabel, attribute: .trailing, relatedBy: .equal, toItem: extraBtn, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let indexLabelH = NSLayoutConstraint(item: indexLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraints([indexLabelLeft, indexLabelY, indexLabelRight, indexLabelH])

        
    }

}
