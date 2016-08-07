//
//  WOWBrandDetailController.swift
//  Wow
//
//  Created by 小黑 on 16/4/11.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit





class WOWBrandDetailController: WOWBaseViewController {
    private let cellID = "WOWBrandDetailCell"
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var underView: WOWBrandUnderView!
    var brandModel:WOWBrandModel!
    private var shareBrandImage:UIImage? //供分享使用

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
//        underView.delegate = self
        configTableView()
    }
    
    private func configTableView(){
//        underView.backgroundColor = UIColor.clearColor()
//        let imageView = UIImageView(frame:tableView.bounds)
//        imageView.image = UIImage(named: "brandBack")
//        tableView.backgroundView = imageView
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
//        
//        let headerView = WOWBrandHeadView(frame:CGRectMake(0,0,MGScreenWidth,MGScreenWidth * 2/3 - 35))
//        headerView.nameLabel.text = brandModel.name
//        headerView.headImageView.kf_setImageWithURL(NSURL(string:brandModel.image ?? "")!, placeholderImage:UIImage(named: "placeholder_product"))
//        headerView.headImageView.kf_setImageWithURL(NSURL(string:brandModel?.image ?? "")!, placeholderImage: UIImage(named: "placeholder_product"), optionsInfo: nil, completionHandler: {[weak self](image, error, cacheType, imageURL) in
//            if let strongSelf = self{
//                strongSelf.shareBrandImage = image
//            }
//        })
//        
//        
//        headerView.nameLabel.shadowOffset = CGSizeMake(1, 1)
//        headerView.backImageView.hidden = true
//        headerView.delegate = self
//        headerView.backgroundColor = UIColor.clearColor()
//        tableView.tableHeaderView = headerView
//        tableView.registerNib(UINib.nibName(String(WOWBrandDetailCell)), forCellReuseIdentifier:cellID)
//        tableView.addTapGesture {[weak self] (tap) in
//            if let strongSelf = self{
//                strongSelf.dismissViewControllerAnimated(true, completion:nil)
//            }
//        }
    }
    
    @IBAction func back(sender: UIButton) {
        dismissViewControllerAnimated(true, completion:nil)
    }
}

extension WOWBrandDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! WOWBrandDetailCell
        cell.backgroundColor = UIColor.clearColor()
        cell.desTextLabel.textColor = MGRgb(0, g: 0, b: 0, alpha: 0.5)
        cell.desTextLabel?.text = brandModel.desc
        cell.desTextLabel.shadowOffset = CGSizeMake(1, 1)
        return cell
    }
}

extension WOWBrandDetailController:UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}

extension WOWBrandDetailController:WOWActionDelegate{
    func itemAction(tag: Int) {
        switch tag {
        case WOWItemActionType.Share.rawValue:
            WOWShareManager.share(brandModel?.name, shareText:brandModel?.desc, url:brandModel?.url,shareImage:shareBrandImage ?? UIImage(named: "me_logo")!)
        case WOWItemActionType.Brand.rawValue:
            dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
}
