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
    
    var timerOverEvent  : TimerOver!

    var stamp           : Int       = 0
    var isConfigCellUI  :Bool       = false
    private var myContext           = 0
    var _timeStamp: Int             = 0
    var myQueueTimer: DispatchQueue?
    var myTimer: DispatchSourceTimer?
    var model : WOWProductModel? {
        didSet {
            if isConfigCellUI == false{
                isConfigCellUI = true
                self.getDetailTimeWithTimestamp(timeStamp: model?.timeoutSeconds ?? 0)
                model?.addObserver(self, forKeyPath: "timeoutSeconds", options: NSKeyValueObservingOptions.new, context: &myContext);
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
                
                self.timerCount(timeStamp: newValue)
                
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
    // 利用KVO完成倒计时
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//         print(change?[NSKeyValueChangeKey.newKey] as! NSInteger?)
        if let timerNumber = change?[NSKeyValueChangeKey.newKey] as? NSInteger {
            
            if timerNumber > 0{
                self.getDetailTimeWithTimestamp(timeStamp: timerNumber)
            }else{
                model?.removeObserver(self, forKeyPath: "timeoutSeconds", context: &myContext)
            }
            
        }
        
    }
    func timerr()  {
        self._timeStamp -= 1
        self.getDetailTimeWithTimestamp(timeStamp: _timeStamp)
        if self._timeStamp == 0 {
            self.timerOver()
        }
    }
    func timerOver()  {
    
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
        
        DispatchQueue.main.async {
            
            self.lbTimerHour.text = String(hour).AddZero()
            self.lbTimerMinute.text = String(minute).AddZero()
            self.lbTimerSecond.text = String(second).AddZero()
            
        }

       
    }
    // 利用GCD 完成倒计时
    func timerCount(timeStamp: NSInteger){
        var timeStamp = timeStamp
        myQueueTimer = DispatchQueue(label: "myQueueTimer")
        myTimer = DispatchSource.makeTimerSource(flags: [], queue: myQueueTimer!)
        myTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(1) ,leeway:.milliseconds(10))
        myTimer?.setEventHandler {
                if timeStamp > 0{
                    
                    timeStamp  = timeStamp - 1
                    self.getDetailTimeWithTimestamp(timeStamp: timeStamp)
                }
        }
        
        myTimer?.resume()
        
    }

}
extension String{
    func AddZero() -> String{
        if self.length == 1 {
            return "0" + self
        }else{
            return self
        }
    }
}
