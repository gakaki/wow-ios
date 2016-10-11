//
//  SimpleHUD.swift
//  ImageBrowser
//
//  Created by jasnig on 16/5/15.
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

class SimpleHUD: UIView {
    
    class LoadingView: UIView {
        
        fileprivate let lineWidth: CGFloat = 8.0
        fileprivate var radius: CGFloat {
            return min(zj_width, zj_height) * 0.5
        }
        
        fileprivate var progressText: String = "0%" {
            didSet {
                addSubview(progressLabel)
                progressLabel.text = progressText
            }
        }
        
        fileprivate lazy var progressLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 10.0, y: (self.zj_height - 30.0) * 0.5, width: self.zj_width - 20.0, height: 30.0))
            label.center = self.center
            label.font = UIFont.boldSystemFont(ofSize: 16.0)
            label.textColor = UIColor.white
            label.textAlignment = .center
            
            return label
        }()
        
        
        var progress: Double = 0.0 {
            didSet {
                //            print(progress)
                if progress >= 1.0 { // 加载完成
                    removeFromSuperview()
                }
                progressText = "\(String(format: "%.0f", progress * 100))%"
                
                // 调用这个方法会执行drawRect方法
                setNeedsDisplay()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.black.withAlphaComponent(0.3)
            layer.cornerRadius = frame.size.width * 0.5
            layer.masksToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func draw(_ rect: CGRect) {
            
            
            let context = UIGraphicsGetCurrentContext()
            
            // 画圆环
            context?.setLineWidth(lineWidth)
            
            context?.setLineCap(.round)
//            let endAngle = CGFloat(progress * M_PI * 2 - M_PI_2 + 0.01)
            
            //TODO
//            CGContextAddArc(context, rect.size.width/2, rect.size.height/2, radius, -CGFloat(M_PI_2), endAngle, 0)

            context?.setStrokeColor(UIColor.white.cgColor)
            context?.strokePath()
            
        }
        
    }
    
    /// 加载错误提示
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: (self.bounds.size.width - 80.0) * 0.5, y:0.0, width: 80.0 , height: 30.0))
        
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.backgroundColor = UIColor.black
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.layer.masksToBounds = true
        
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        return label
    }()
    
    var progress: Double = 0.01 {
        willSet {
            loadingView.progress = newValue
        }
    }
    
    fileprivate lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: CGRect(x: (self.bounds.width - 80)*0.5, y: (self.bounds.height - 80)*0.5, width: 80.0, height: 80.0))
        return loadingView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addLoadingView() {
        messageLabel.removeFromSuperview()
        addSubview(loadingView)
        
    }
    
    ///
    ///
    ///  - parameter autoHide: 是否自动隐藏
    ///  - parameter time:     自动隐藏的时间 只有当autoHide = true的时候有效
    func showHUD(_ text: String, autoHide: Bool, afterTime time: Double) {
        
        loadingView.removeFromSuperview()
        addSubview(messageLabel)
        messageLabel.text = text
        
        let textSize = (text as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: messageLabel.font], context: nil)
        messageLabel.frame = CGRect(x: (self.bounds.width - textSize.width - 16)*0.5, y: (self.bounds.height - 40.0)*0.5, width: textSize.width + 16, height: 40.0)
        
        messageLabel.layer.cornerRadius = messageLabel.bounds.height / 2

        
        if autoHide {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[unowned self] in
                self.hideHUD()
                
            })
        }
        
    }
    func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    func hideHUD() {
        self.removeFromSuperview()
    }
}
