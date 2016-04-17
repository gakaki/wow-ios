//
//  WOWStoreController.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/18.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWStoreController: WOWBaseViewController {
    let cellID1  = String(WOWStoreBrandCell)
    let cellID2 = String(WOWMenuCell)
    var dataArr = [WOWCategoryModel]()
    var cycleView:CyclePictureView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
//MARK:Private Method
    
    override func setUI() {
        super.setUI()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.registerNib(UINib.nibName(String(WOWStoreBrandCell)), forCellReuseIdentifier:cellID1)
        configHeaderView()
    }
    
    private func initData(){
        let categorys = WOWRealm.objects(WOWCategoryModel)
        dataArr = []
        for model in categorys {
            dataArr.append(model)
        }
    }
    
    private func configHeaderView(){
        cycleView = CyclePictureView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: MGScreenWidth * 215/375), imageURLArray: nil)
        cycleView.placeholderImage = UIImage(named: "test2")
        //FIXME:修改图片Url
        cycleView.imageURLArray = ["http://pic1.zhimg.com/05a55004e42ef9d778d502c96bc198a4.jpg","http://pic1.zhimg.com/05a55004e42ef9d778d502c96bc198a4.jpg"]
        tableView.tableHeaderView = cycleView
    }
    
    /*
    private func addObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(updateCategory), name:WOWCategoryUpdateNotificationKey, object: nil)
    }
    */
    
//MARK:Actions
    
    
}


extension WOWStoreController:BrandCellDelegate{
    func hotBrandCellClick() {
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandHomeController)) as! WOWBrandHomeController
        vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension WOWStoreController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return dataArr.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID1, forIndexPath: indexPath) as! WOWStoreBrandCell
            cell.delegate = self
            tableViewCell = cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID2, forIndexPath: indexPath) as! WOWMenuCell
            cell.showDataModel(dataArr[indexPath.row])
            tableViewCell = cell
        }
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return MGScreenWidth
        }else{
            return 55
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { //分类
            let item = dataArr[indexPath.row]
            let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsController)) as! WOWGoodsController
            vc.navigationItem.title = item.categoryName
            vc.menuIndex = indexPath.row
            vc.menuTitles = categoryTitles
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    var categoryTitles:[String]{
        get{
          return dataArr.map { (model) -> String in
                return model.categoryName
            }
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
            sectionView.leftLabel.text = "热门品牌"
            //FIXME:修改掉
            sectionView.rightDetailLabel.text = "全部\(999)个品牌"
            sectionView.rightBackView.addAction({[weak self] in
                if let strongSelf = self{
                    let brandVC = UIStoryboard.initialViewController("Store", identifier:String(WOWBrandListController)) as! WOWBrandListController
                    strongSelf.navigationController?.pushViewController(brandVC, animated: true)
                }
                })
            return sectionView
        }else{
            let sectionView =  NSBundle.mainBundle().loadNibNamed(String(WOWStoreSectionView), owner: self, options: nil).last as! WOWStoreSectionView
            sectionView.leftLabel.text = "商品分类"
            sectionView.rightBackView.hidden = true
            return sectionView
        }
    }
}


