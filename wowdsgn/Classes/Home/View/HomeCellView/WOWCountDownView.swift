//
//  WOWTimer.swift
//  WOWTimer
//
//  Created by 陈旭 on 2016/10/19.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
typealias TimerOver = () -> ()
class WOWCountDownView: UIView {
    var timerOverEvent : TimerOver!
    var timer : Timer? = nil
    var stamp : Int = 0
    
    var _timeStamp: Int = 0
    
    var timeStamp: Int {
        get {
            
            return self._timeStamp
        }
        
        set {
            if newValue != 0{
                _timeStamp = newValue
                
                if timer == nil {
                     timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerr), userInfo: nil, repeats: true)
                }
               
                self.getDetailTimeWithTimestamp(timeStamp: newValue )
               
            }else{
                
            }

        }
    }
    
    @IBOutlet weak var lbTimerHour: UILabel!
    @IBOutlet weak var lbTimerMinute: UILabel!
    @IBOutlet weak var lbTimerSecond: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

        lbTimerHour.AddBorderRadius()
        lbTimerMinute.AddBorderRadius()
        lbTimerSecond.AddBorderRadius()
        
    }
    func timerr()  {
        self._timeStamp -= 1
        self.getDetailTimeWithTimestamp(timeStamp: _timeStamp)
        if self._timeStamp == 0 {
            self.timerOver()
        }
    }
    func timerOver()  {
        timer?.invalidate()
        timer = nil
        timerOverEvent()
    }
    
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
        self.lbTimerHour.text = String(hour)
        self.lbTimerMinute.text = String(minute)
        self.lbTimerSecond.text = String(second)
    }
    
}
