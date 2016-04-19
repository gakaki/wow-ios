//
//  WOWUserController.swift
//  Wow
//
//  Created by 小黑 on 16/4/6.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWUserController: WOWBaseTableViewController {
    var rightItem:WOWNumberMessageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setUI() {
        super.setUI()
        /**
         暂时社区干掉
         */
//        configRightNav()
        configHeaderView()
        addObserver()
    }

//MARK:Private Method
    
    private func configRightNav(){
        rightItem = WOWNumberMessageView(frame:CGRectMake(0,0,50,30))
        rightItem.sizeToFit()
        rightItem.addAction {[weak self] in
            if let strongSelf = self{
                let vc = UIStoryboard.initialViewController("User", identifier:String(WOWMessageController)) as! WOWMessageController
                strongSelf.navigationController?.pushViewController(vc, animated:true)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItem)
    }
    
    private func configHeaderView(){
        func gotoSociety(type:SocietyType){
            let soc = UIStoryboard.initialViewController("User", identifier:"WOWMeSocietyController") as! WOWMeSocietyController
            soc.society = type
            navigationController?.pushViewController(soc, animated: true)
        }
        
        let header = WOWUserTopView()
        header.frame = CGRectMake(0, 0, MGScreenWidth, 120)
        header.topContainerView.addAction {[weak self] in
            if let strongSelf = self{
                strongSelf.goLogin()
            }
        }
        header.focusBackView.addAction {[weak self] in
            if let _ = self{
                gotoSociety(SocietyType.Focus)
            }
        }
        
        header.fansBackView.addAction {[weak self] in
            if let _ = self{
                gotoSociety(SocietyType.Fans)
            }
        }
        
        self.tableView.tableHeaderView = header
        
        
    }
    
    private func goUserInfo(){
        let vc = UIStoryboard.initialViewController("User", identifier:String(WOWUserInfoController))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goLogin(){
        let vc = UIStoryboard.initialViewController("Login", identifier: "WOWLoginNavController")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(loginSuccess), name:WOWLoginSuccessNotificationKey, object:nil)
    }
    
    
    
//MARK:Actions
    func loginSuccess(){
        
    }
    
    
}


//MARK:Delegate
extension WOWUserController{
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section {
        case 0://订单
            let vc = UIStoryboard.initialViewController("User", identifier:String(WOWOrderController)) as! WOWOrderController
            vc.selectIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        case 2://设置
            let vc = UIStoryboard.initialViewController("User", identifier:String(WOWSettingController)) as! WOWSettingController
            navigationController?.pushViewController(vc, animated: true)
        case 1://喜欢的
            let vc = UIStoryboard.initialViewController("User", identifier:"WOWILikeController") as! WOWILikeController
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    var types:[String]{
        get{
            return ["我的订单","我喜欢的"]
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1:
            return 40
        default:
            return 20
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0,1:
            let v = SectionView(frame:CGRectMake(0,0,MGScreenWidth,40))
            v.label.text = types[section]
            return v
        default:
            return nil
        }
    }
}


class SectionView: UIView {
    var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textColor = GrayColorlevel3
        label.font = Fontlevel003
        self.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}