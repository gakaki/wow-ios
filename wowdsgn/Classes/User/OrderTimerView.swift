//
//  OrderTimerView.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/12/20.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit

class OrderTimerView: UIView {
    
    var lbTimer: UILabel!
    
    var myQueueTimer: DispatchQueue?
    var myTimer: DispatchSourceTimer?
    
    var _timeStamp: Int             = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        lbTimer = UILabel()
        
        self.addSubview(lbTimer)
        
        lbTimer.text            = ""
        lbTimer.font            = UIFont.systemFont(ofSize: 12)
        lbTimer.numberOfLines   = 0
        lbTimer.textColor       = UIColor.init(hexString: "FFFFFF")
        lbTimer.textAlignment   = .center
        lbTimer.backgroundColor = UIColor.init(hexString: "202020")
        
        lbTimer.snp.makeConstraints {[weak self] (make) -> Void in
            if  let strongSelf = self {
    
                
                make.width.equalTo(MGScreenWidth)
                make.height.equalTo(38)
                make.top.right.equalTo(strongSelf)
                
                
            }

        }
        
    }
    var timeStamp: Int {
        get {
            
            return self._timeStamp
        }
        set {
            if newValue != 0{
                _timeStamp = newValue
                
                self.getDetailTimeWithTimestamp(timeStamp: newValue )
                
                
            }else{
                
                self.getDetailTimeWithTimestamp(timeStamp: newValue )
                
            }
            
        }
    }
    
    // 实时更改UI显示数据
    func getDetailTimeWithTimestamp(timeStamp: NSInteger)  {
        
        let ms = timeStamp
        let ss = 1
        let mi = ss * 60
        let hh = mi * 60
        let dd = hh * 24
        let day = ms / dd
        
        let hour = (ms - day * dd) / hh
        let minute = (ms - day * dd - hour * hh) / mi
        let second = (ms - day * dd - hour * hh - minute * mi) / ss
        
        let timerStr = String(minute).AddZero() + "分钟" + String(second).AddZero() + "秒"
        
        self.lbTimer.colorRangeWithText("您的订单已提交，请在", str2: timerStr, str3: "内完成支付",changeColor: UIColor.init(hexString: "FFD444")!)
  
        
    }
    // 利用GCD 完成倒计时
    func timerCount(timeStamp: NSInteger){
        var timeStamp = timeStamp
        myQueueTimer = DispatchQueue(label: "myQueueTimer")
        myTimer = DispatchSource.makeTimerSource(flags: [], queue: myQueueTimer!)
        myTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(10))
        myTimer?.setEventHandler {
            if timeStamp >= 1{
                
                timeStamp  = timeStamp - 1
                self.getDetailTimeWithTimestamp(timeStamp: timeStamp)
            }else{
                self.getDetailTimeWithTimestamp(timeStamp: timeStamp)
            }
        }
        
        myTimer?.resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

