//
//  WOWSearchsController.swift
//  WowDsgn
//
//  Created by 小黑 on 16/5/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

class WOWSearchsController: WOWBaseViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataArr = [WOWProductModel]()
    var keyword : String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.hidden = true
    }

    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
        self.navigationItem.title = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchView.hidden = false
//        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK:Lazy
    lazy var searchView:WOWSearchBarView = {
        let view = NSBundle.mainBundle().loadNibNamed(String(WOWSearchBarView), owner: self, options: nil).last as! WOWSearchBarView
        view.frame = CGRectMake(15, 8, MGScreenWidth - 30,30)
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.5).CGColor
        view.searchTextField.delegate = self
        view.searchTextField.becomeFirstResponder()
        view.cancelButton.addTarget(self, action:#selector(cancel), forControlEvents:.TouchUpInside)
        return view
    }()
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationController?.navigationBar.addSubview(searchView)
        navigationItem.leftBarButtonItems = nil
        collectionView.registerNib(UINib.nibName(String(WOWGoodsSmallCell)), forCellWithReuseIdentifier:"WOWGoodsSmallCell")
        collectionView.mj_header = self.mj_header
        makeCustomerNavigationItem("", left: true, handler:nil)
    }
    
//MARK:Actions
    func cancel(){
        searchView.searchTextField.resignFirstResponder()
        navigationController?.popViewControllerAnimated(true)
    }
    
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_ProductList(pageindex: String(pageIndex), categoryID:"", style:"", sort: "", uid:"",keyword:keyword ?? ""), successClosure: {[weak self](result) in
            if let strongSelf = self{
                let json = JSON(result)
                DLog(json)
                let totalPage = JSON(result)["total_page"].intValue
                if strongSelf.pageIndex == totalPage - 1 || totalPage == 0{
                    strongSelf.collectionView.mj_footer = nil
                }else{
                    strongSelf.collectionView.mj_footer = strongSelf.mj_footer
                }
                let goodsArr  = JSON(result)["rows"].arrayObject
                if let arr  = goodsArr{
                    if strongSelf.pageIndex == 0{
                        strongSelf.dataArr = []
                    }
                    if arr.isEmpty{
                        WOWHud.showMsg("暂无您搜索的商品")
                    }else{
                        WOWHud.dismiss()
                    }
                    for item in arr{
                        let model = Mapper<WOWProductModel>().map(item)
                        if let m = model{
                            strongSelf.dataArr.append(m)
                        }
                    }
                    strongSelf.endRefresh()
                    strongSelf.collectionView.reloadData()
                }else{
                    WOWHud.dismiss()
                }
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }
    }
}




//MARK:Delegate
extension WOWSearchsController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWGoodsSmallCell", forIndexPath: indexPath) as! WOWGoodsSmallCell
        let model = dataArr[indexPath.row]
        cell.showData(model,indexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(WOWGoodsSmallCell.itemWidth,WOWGoodsSmallCell.itemWidth + 65)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(WOWGoodsDetailController)) as! WOWGoodsDetailController
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! WOWGoodsSmallCell
        vc.shareProductImage = cell.pictureImageView.image
        vc.productID = model.productID
         vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWSearchsController:UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch(textField.text ?? "")
        return true
    }

    func startSearch(text:String) {
        guard !text.isEmpty else{
            WOWHud.showMsg("请输入搜索关键字")
            return
        }
        keyword = text
        pageIndex = 0
        request()
    }
}

