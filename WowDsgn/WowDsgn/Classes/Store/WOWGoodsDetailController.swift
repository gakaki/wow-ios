//
//  WOWGoodsDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWGoodsDetailController: WOWBaseViewController {
    var cycleView:CyclePictureView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        self.edgesForExtendedLayout = .None
        configTableView()
        configHeaderView()
        
    }
    
//MARK:Private Method
    private func configTableView(){
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib.nibName(String(WOWGoodsTypeCell)), forCellReuseIdentifier:String(WOWGoodsTypeCell))
        tableView.registerNib(UINib.nibName(String(WOWGoodsDetailCell)), forCellReuseIdentifier:String(WOWGoodsDetailCell))
        tableView.registerNib(UINib.nibName(String(WOWGoodsParamCell)), forCellReuseIdentifier:String(WOWGoodsParamCell))
        //FIXME:需要提取出来
//        tableView.registerNib(UINib.nibName(String(WOWSubArtCell)), forCellReuseIdentifier:String(WOWSubArtCell))
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"argumentCell")
    }
    
    
    private func configHeaderView(){
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth), imageURLArray: nil)
        cycleView.placeholderImage = UIImage(named: "test2")
        //FIXME:修改图片Url
        cycleView.imageURLArray = ["http://pic1.zhimg.com/05a55004e42ef9d778d502c96bc198a4.jpg","http://pic1.zhimg.com/05a55004e42ef9d778d502c96bc198a4.jpg"]
        tableView.tableHeaderView = cycleView
    }
    
    
//MARK:Actions
    @IBAction func back(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
}


extension WOWGoodsDetailController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: //系列
            return 1
        case 1: //图文
            return 5
        case 2: //参数
            return 5
        case 3: //相关场景
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returnCell :UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWGoodsTypeCell), forIndexPath: indexPath) as! WOWGoodsTypeCell
            cell.showData()
            returnCell = cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWGoodsDetailCell), forIndexPath: indexPath) as! WOWGoodsDetailCell
            //FIXME:测试数据
            cell.goodsDesLabel.text = "结合东方礼仪的设计,特有的内嵌杯垫设计，使得咖啡杯在使用过程中保持静音。采用传统釉料与质朴的陶泥结合。丰富釉面变化，让杯子多一份自然的感觉。"
            cell.cellHeightConstraint.constant = CGFloat((indexPath.row + 1) * 20)
            returnCell = cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWGoodsParamCell), forIndexPath: indexPath) as! WOWGoodsParamCell
            cell.paramLabel.text = "参数"
            cell.valueLabel.text = "参数详情参数详情参数详情"
            returnCell = cell
//            var cell = tableView.dequeueReusableCellWithIdentifier("argumentCell")
//            if cell == nil {
//                cell = UITableViewCell(style: .Subtitle, reuseIdentifier:"argumentCell")
//                cell?.textLabel?.font = FontMediumlevel003
//                cell?.detailTextLabel?.font = Fontlevel003
//                cell?.detailTextLabel?.textColor = GrayColorlevel3
//                cell?.textLabel!.text = "参数"
//                cell?.detailTextLabel?.text = "参数详情参数详情参数详情"
//                cell?.imageView?.image = UIImage(named: "goodsWeight")
//                returnCell = cell
//            }
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWSubArtCell),forIndexPath: indexPath) as! WOWSubArtCell
            returnCell = cell
        default:
            DLog("")
        }
        return returnCell
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1:
            return 0.01
        default:
            return 36
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0,3:
            return 0.01
        default:
            return 20
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0,1:
            return nil
        default:
            let headerView = WOWMenuTopView(frame:CGRectMake(0,0,tableView.width,36))
            if section == 2 {
                headerView.leftLabel.text = "产品参数"
                headerView.rightButton.hidden = true
                headerView.showLine(true)
            }else if section == 3{
                headerView.leftLabel.text = "相关场景"
                headerView.rightButton.setImage(UIImage(named: "next_arrow")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
                headerView.rightButton.hidden = false
                headerView.topLine.hidden = false
            }
            return headerView
        }
    }
    
    
}



