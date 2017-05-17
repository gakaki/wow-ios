//
//  WOWMoneyFromController.swift
//  wowdsgn
//
//  Created by 陈旭 on 2017/5/9.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit


class WOWMoneyFromController: WOWApplyAfterBaseController {

    
    let data : [(TimelinePoint, UIColor, UIColor)]
        = [(TimelinePoint(color: YellowColor, filled: true),UIColor.clear,YellowColor),
           (TimelinePoint(color: YellowColor, filled: true),YellowColor,SeprateColor),
           (TimelinePoint(color: SeprateColor, filled: true),SeprateColor,UIColor.clear)]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钱款去向"
        // Do any additional setup after loading the view.
    
  
    }
    override func setUI() {
        super.setUI()
//        tableView.register(UINib.init(nibName: "WOWTimerLineCell", bundle: Bundle.main), forCellReuseIdentifier: "WOWTimerLineCell")
        
        tableView.register(UINib.nibName("WOWTimerLineCell"), forCellReuseIdentifier: "WOWTimerLineCell")
        
        tableView.register(UINib.nibName("WOWMoneyTopCell"), forCellReuseIdentifier: "WOWMoneyTopCell")
//        tableView.register(UINib.init(nibName: "WOWMoneyTopCell", bundle: Bundle.main), forCellReuseIdentifier: "WOWMoneyTopCell")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count + 1
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 0 else {
            let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWMoneyTopCell", for: indexPath) as! WOWMoneyTopCell
            
            return cell
        }
        
        let cell                = tableView.dequeueReusableCell(withIdentifier: "WOWTimerLineCell", for: indexPath) as! WOWTimerLineCell
        let (timelinePoint, timeLineTopColor, timeLineBottomColor) = data[indexPath.row - 1]
        cell.timelinePoint          = timelinePoint
        cell.timeline.frontColor    = timeLineTopColor
        cell.timeline.backColor     = timeLineBottomColor
        return cell
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
