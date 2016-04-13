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
    @IBOutlet weak var priceLabel: UILabel!
    var goodsDetailEntrance:GoodsDetailEntrance = .FromGoodsList
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        switch goodsDetailEntrance {
        case .FromBrand,.FromSence:
            return
        default:
            break
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
        tableView.registerNib(UINib.nibName(String(WOWSubArtCell)), forCellReuseIdentifier:String(WOWSubArtCell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))
        tableView.registerNib(UINib.nibName(String(WOWCommentCell)), forCellReuseIdentifier:String(WOWCommentCell))

    }
    
    private func configHeaderView(){
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth), imageURLArray: nil)
        cycleView.placeholderImage = UIImage (named: "test2")
        //FIXME:修改图片Url
        cycleView.imageURLArray = ["http://pic1.zhimg.com/05a55004e42ef9d778d502c96bc198a4.jpg","http://pic1.zhimg.com/05a55004e42ef9d778d502c96bc198a4.jpg"]
        tableView.tableHeaderView = cycleView
    }
    
    
//MARK:Actions
    @IBAction func back(sender: UIButton) {
//        navigationController?.popViewControllerAnimated(true)
        switch WOWMediator.goodsDetailSecondEntrance {
        case .FromGoodsList,.FromSence:
            navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
        case .FromBrand:
            let vcs = navigationController?.viewControllers
            vcs?.forEach({ (viewcontroller) in
                if viewcontroller is WOWBrandHomeController{
                    navigationController?.popToViewController(viewcontroller, animated: true)
                }
            })
        }
    }
    
    @IBAction func likeButtonClick(sender: UIButton) {
        DLog("收藏")
    }
    
    @IBAction func shareButtonClick(sender: UIButton) {
        DLog("分享")
    }
    @IBAction func buyButtonClick(sender: UIButton) {
        
    }
    
    
}




extension WOWGoodsDetailController:WOWSubAlertDelegate{
    func subAlertItemClick() {
        let sence = UIStoryboard.initialViewController("Home", identifier:String(WOWSenceController)) as! WOWSenceController
        sence.hideNavigationBar = true
        sence.senceEntrance = .FromGoods
        navigationController?.pushViewController(sence, animated: true)
    }
}


extension WOWGoodsDetailController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 6
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
        case 4: //喜欢
            return 1
        case 5: //评论
            return 5
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
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWSubArtCell),forIndexPath: indexPath) as! WOWSubArtCell
            cell.delegate = self
            returnCell = cell
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWSenceLikeCell),forIndexPath: indexPath) as! WOWSenceLikeCell
            cell.moreLikeButton.addTarget(self, action: #selector(moreLikeButtonClick), forControlEvents:.TouchUpInside)
            returnCell = cell
        case 5:
            let cell = tableView.dequeueReusableCellWithIdentifier(String(WOWCommentCell),forIndexPath: indexPath)as!WOWCommentCell
            cell.hideHeadImage()
            //FIXME:测试数据
            cell.commentLabel.text = "我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君"
            returnCell = cell
        default:
            DLog("")
        }
        return returnCell
    }
    
    func moreLikeButtonClick(){
        let likeVC = UIStoryboard.initialViewController("Home", identifier:String(WOWLikeListController))
        navigationController?.pushViewController(likeVC, animated: true)
    }
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1,4:
            return 0.01
        default:
            return 36
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0,3,4:
            return 0.01
        case 5: //评论
            return 44
        default:
            return 20
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0,1:
            return nil
        case 2://参数
            return WOWMenuTopView(leftTitle: "产品参数", rightHiden: true, topLineHiden: false, bottomLineHiden: false)
        case 3: //相关场景
           return WOWMenuTopView(leftTitle: "相关场景", rightHiden: true, topLineHiden: false, bottomLineHiden: true)
        case 5: //评论
            let view =  WOWMenuTopView(leftTitle: "xx条评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
            goComment(view)
            return view
        default:
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 5 {
            let footerView = WOWMenuTopView(leftTitle: "发表评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
            goComment(footerView)
            return footerView
        }
        return nil
    }
    
    private func goComment(commentView:UIView!){
        commentView.addAction{[weak self] in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    
}



