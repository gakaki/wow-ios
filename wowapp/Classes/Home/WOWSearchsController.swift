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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        self.navigationItem.title = ""
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchView.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//MARK:Lazy
    lazy var searchView:WOWSearchBarView = {
        let view = Bundle.main.loadNibNamed(String(describing: WOWSearchBarView()), owner: self, options: nil)?.last as! WOWSearchBarView
        view.frame = CGRect(x: 15, y: 8, width: self.view.w - 30,height: 30)
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        view.searchTextField.delegate = self
        view.searchTextField.becomeFirstResponder()
        view.cancelButton.addTarget(self, action:#selector(cancel), for:.touchUpInside)
        return view
    }()
    
//MARK:Private Method
    override func setUI() {
        super.setUI()
        navigationController?.navigationBar.addSubview(searchView)
        navigationItem.leftBarButtonItems = nil
        collectionView.register(UINib.nibName(String(describing: WOWGoodsSmallCell.self)), forCellWithReuseIdentifier:"WOWGoodsSmallCell")
        collectionView.mj_header = self.mj_header
        makeCustomerNavigationItem("", left: true, handler:nil)
    }
    
//MARK:Actions
    func cancel(){
        searchView.searchTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
//MARK:Network
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_ProductList(pageindex: String(pageIndex), categoryID:"", style:"", sort: "", uid:"",keyword:keyword ?? ""), successClosure: {[weak self](result) in
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
                        let model = Mapper<WOWProductModel>().map(JSONObject:item)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWGoodsSmallCell", for: indexPath) as! WOWGoodsSmallCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        cell.showData(model,indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: WOWGoodsSmallCell.itemWidth,height: WOWGoodsSmallCell.itemWidth + 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[(indexPath as NSIndexPath).row]
        let vc = UIStoryboard.initialViewController("Store", identifier:String(describing: WOWProductDetailController())) as! WOWProductDetailController
        vc.productId = model.productId
         vc.hideNavigationBar = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WOWSearchsController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        startSearch(textField.text ?? "")
        return true
    }

    func startSearch(_ text:String) {
        guard !text.isEmpty else{
            WOWHud.showMsg("请输入搜索关键字")
            return
        }
        keyword = text
        pageIndex = 0
//        request()
    }
}


extension WOWSearchsController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchView.searchTextField.resignFirstResponder()
    }
}

