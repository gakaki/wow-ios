//
//  WOWUserCommentVC.swift
//  wowdsgn
//
//  Created by 陈旭 on 2016/11/24.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
// 记录用户选择的图片的数据
class UserPhotoManage: NSObject {
    
    var imageArr        = [UIImage]()
    var userIndexSection : Int?
    var assetsArr       = [AnyObject]()
    var UserCommentDic  : [String:AnyObject]?
}
// 记录用户评论的操作
class UserCommentManage :NSObject,CGYJSON{
    
    var saleOrderItemId         : Int?
    var comments                : String?
    var commentImgs             : [String]?
  
}
class WOWUserCommentVC: WOWBaseViewController,TZImagePickerControllerDelegate,PushCommentDelegate {
    fileprivate var dataImageArr    = [UIImage]()// 存放选择的image对象
    
    fileprivate var dataArr         = [WOWProductPushCommentModel]()// 列表cell的数据源
    
    fileprivate var commentArr      = [String]() // 存放评论信息的数组
    
    
    fileprivate var productCommentDic : [String:AnyObject]?
    
    var collectionViewOfDataSource  = Dictionary<Int, UserPhotoManage>() //空字典,记录每个 cell上面的选择图片的数据
    var orderCode   :String!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

    override func setUI() {
        self.tableView.register(UINib.nibName("WOWPushCommentCell"), forCellReuseIdentifier: "WOWPushCommentCell")
        self.tableView.delegate             = self
        self.tableView.dataSource           = self
        self.tableView.rowHeight            = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight   = 300
        request()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func request() {
        super.request()
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderComment(orderCode: orderCode), successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                let json = JSON(result)
                DLog(json)
                let bannerList = Mapper<WOWProductPushCommentModel>().mapArray(JSONObject:JSON(result)["saleOrderItemList"].arrayObject)
                
                if let bannerList = bannerList{
                    strongSelf.dataArr = bannerList
//                    for commentModel in bannerList {
//                        
//                        let user = UserCommentManage()// 拿到统一的 评论对象
//                        user.saleOrderItemId = commentModel.saleOrderItemId
//                        strongSelf.commentArr.append(user)
//                    }
                }
                
                strongSelf.endRefresh()
                strongSelf.tableView.reloadData()
                
     
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }

    }
    
    
    // 选择照片
    func pushImagePickerController(collectionViewTag: Int)  {
        
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: 5, columnNumber: 5, delegate: self, pushPhotoPickerVc: true)
        imagePickerVc?.isSelectOriginalPhoto            = false
        
        imagePickerVc?.barItemTextColor                 = UIColor.black
        imagePickerVc?.navigationBar.barTintColor       = UIColor.black
        imagePickerVc?.navigationBar.tintColor          = UIColor.black
        
        let model = collectionViewOfDataSource[collectionViewTag]
        
        imagePickerVc?.selectedAssets       = NSMutableArray.init(array: (model?.assetsArr) ?? [])
        imagePickerVc?.allowTakePicture     = true // 拍照按钮将隐藏,用户将不能在选择器中拍照
        imagePickerVc?.allowPickingVideo    = false// 用户将不能选择发送视频
        imagePickerVc?.allowPickingImage    = true // 用户可以选择发送图片
        imagePickerVc?.allowPickingOriginalPhoto = false// 用户不能选择发送原图
        imagePickerVc?.sortAscendingByModificationDate = false// 是否按照时间排序
        
        
        
        imagePickerVc?.didFinishPickingPhotosHandle = {[weak self](images,asstes,isupdete) in
            if let strongSelf = self,let images = images,let asstes = asstes {
                
                let model = UserPhotoManage()
                
                model.imageArr          = images
                model.assetsArr         = asstes as [AnyObject]
                model.userIndexSection  = collectionViewTag
                
                strongSelf.collectionViewOfDataSource[collectionViewTag] = model
                //                let indexPath = NSIndexPath.init(row: 0, section: collectionViewTag)
                //                strongSelf.tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
                strongSelf.tableView.reloadData()
                
            }
        }
        present(imagePickerVc!, animated: true, completion: nil)
    }

   
    @IBAction func puchClickAction(_ sender: Any) {
        print("点击了")
        for model in self.dataArr.enumerated(){
            
            let user = UserCommentManage()// 拿到统一的 评论对象
            user.saleOrderItemId = model.element.saleOrderItemId
            user.comments = "aaaa" + String(model.offset)
            
            self.commentArr.append(user.toJSONString()!)
        }
        
        
        
        var params = [String: AnyObject]()
        
        params = ["commentDetails": self.commentArr as AnyObject]
        
        print("json----\(params)")
        WOWNetManager.sharedManager.requestWithTarget(.api_OrderPushComment(params: nil) , successClosure: {[weak self] (result, code) in
            WOWHud.dismiss()
            if let strongSelf = self{
                
                
                let json = JSON(result)
                DLog(json)
//                let bannerList = Mapper<WOWProductCommentModel>().mapArray(JSONObject:JSON(result)["saleOrderItemList"].arrayObject)
//                
//                if let bannerList = bannerList{
//                    strongSelf.dataArr = bannerList
//                }
//                
//                strongSelf.endRefresh()
//                strongSelf.tableView.reloadData()
                
                
                
                
            }
        }) {[weak self] (errorMsg) in
            if let strongSelf = self{
                strongSelf.endRefresh()
                WOWHud.dismiss()
            }
        }

    }
}
extension WOWUserCommentVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WOWPushCommentCell.self), for: indexPath) as! WOWPushCommentCell

        
        cell.modelData = self.dataArr[indexPath.section]
        
        let model = self.collectionViewOfDataSource[indexPath.section]

        if let model = model{
            
            cell.showImageView(model)
            
        }else{// 如果无 给空，防止重用导致布局错误
            
            cell.dataImageArr = [UIImage]()
        }
       
        cell.indexPathSection   = indexPath.section
        cell.delegate           = self
        cell.selectionStyle     = .none
        return cell
    }
}
public protocol CGYJSON {
    func toJSONModel() -> AnyObject?
    func toJSONString() -> String?
}

extension CGYJSON {
    public func toJSONModel() -> AnyObject? {
        let mirror = Mirror(reflecting: self)
        guard mirror.children.count > 0 else {
            return self as? AnyObject
        }
        var result: [String: AnyObject] = [:]
        var superClss = mirror.superclassMirror
        while superClss != nil {
            for case let (label?, value) in superClss!.children {
                if let jsonValue = value as? CGYJSON {
                    result[label] = jsonValue.toJSONModel()
                }
            }
            superClss = superClss?.superclassMirror
        }
        for case let (label?, value) in mirror.children {
            if let jsonValue = value as? CGYJSON {
                result[label] = jsonValue.toJSONModel()
            }
        }
        return result as AnyObject?
    }
    
    public func toJSONString() -> String? {
        guard let jsonModel = self.toJSONModel() else {
            return nil
        }
        let data = try? JSONSerialization.data(withJSONObject: jsonModel, options: [])
        let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        return str as? String
    }
}

extension Optional: CGYJSON {
    public func toJSONModel() -> AnyObject? {
        if let _self = self {
            if let value = _self as? CGYJSON {
                return value.toJSONModel()
            }
        }
        return NSNull()
    }
}

extension Array: CGYJSON {
    public func toJSONModel() -> AnyObject? {
        var results: [AnyObject] = []
        for item in self {
            if let ele = item as? CGYJSON {
                if let eleModel = ele.toJSONModel() {
                    results.append(eleModel)
                }
            }
        }
        return results as AnyObject?
    }
}

extension Dictionary: CGYJSON {
    public func toJSONModel() -> AnyObject? {
        var results: [String: AnyObject] = [:]
        for (key, value) in self {
            if let key = key as? String {
                if let value = value as? CGYJSON {
                    if let valueModel = value.toJSONModel() {
                        results[key] = valueModel
                        continue
                    }
                } else if let value = value as? AnyObject {
                    results[key] = value
                    continue
                }
                results[key] = NSNull()
            }
        }
        return results as AnyObject?
    }
}
