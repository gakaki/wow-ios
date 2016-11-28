//
//  WOWPushCommentCell.swift
//  UpdatePhotoDemo
//
//  Created by 陈旭 on 2016/11/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit

protocol PushCommentDelegate:class {
    func pushImagePickerController(collectionViewTag: Int)
}
class WOWPushCommentCell: UITableViewCell,TZImagePickerControllerDelegate {
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    @IBOutlet weak var lbDes: UILabel!
    
    @IBOutlet weak var lbTitle: UILabel!
    
//    @IBOutlet weak var textView: HolderTextView!
    
    var dataImageArr = [UIImage](){
        didSet{
            collectionView.reloadData()
        }
    }
    
    var modelPhotosData               :    UserPhotoManage?
    var userCommentData               :    UserCommentManage?{
        didSet{
            if userCommentData?.comments?.isEmpty == true {
                inputTextView.placeholderText = "请写下您的购物体验和使用感受"
            }else{
                inputTextView.text = userCommentData?.comments ?? ""
            }
        
        }
       
    }
    weak var delegate                 :    PushCommentDelegate?
    
    var maxNumPhoto                 = 5 // 最多显示几个
    var collectionViewOfDataSource  = Dictionary<Int, [UIImage]>() //空字典
    
    var modelData : WOWProductPushCommentModel?{
        
        didSet{
            self.lbTitle.text = modelData?.productName
            self.imgProduct.set_webimage_url(modelData?.productImg ?? "")
            var desStr : String?
            for str in modelData?.specAttribute ?? [""] {
                desStr = (desStr ?? "") + str
            }
            inputTextView.tag = modelData?.saleOrderItemId ?? 0
            
            self.lbDes.text = desStr
        }
    }

    var indexPathSection : Int? = 0{// 记录当前的CollectionView，为了维持上面的数据
        didSet{
 
            collectionView.tag = indexPathSection ?? 0
         
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgShop: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        inputTextView.delegate = self
        
        collectionView.register(UINib.nibName(String(describing: WOWSingPhotoCVCell.self)), forCellWithReuseIdentifier:String(describing: WOWSingPhotoCVCell.self))
    
        collectionView.delegate                         = self
        collectionView.dataSource                       = self
    
        collectionView.showsVerticalScrollIndicator     = false
        collectionView.showsHorizontalScrollIndicator   = false
  
    }
    
    
    
    // UI数据
    func showImageView(_ m:UserPhotoManage)  {
        
        self.modelPhotosData      = m
        self.dataImageArr   = m.imageArr
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension WOWPushCommentCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = (dataImageArr.count == 0 ?  1 : dataImageArr.count + 1)
        
        return number >= maxNumPhoto ? maxNumPhoto : number// 最多显示 5个
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWSingPhotoCVCell.self), for: indexPath) as! WOWSingPhotoCVCell
        if dataImageArr.count > 0 && indexPath.row < dataImageArr.count{
            
            cell.imgPhoto.image = dataImageArr[indexPath.row]
            cell.datelebtn.isHidden = false
            cell.datelebtn.addTapGesture(action: {[weak self] (sender) in// 点击删除图片操作
                if let strongSelf = self {
                    
                    strongSelf.dataImageArr.remove(at: indexPath.row)// 更改当前CollectionView

                    strongSelf.modelPhotosData?.imageArr.remove(at: indexPath.row)// 更改原始数据层，用户选中的image
                    strongSelf.modelPhotosData?.assetsArr.remove(at: indexPath.row)// 用户选中的image Assets
                    strongSelf.userCommentData?.commentImgs?.remove(at: indexPath.row)// 用户选择image 的Url数组
                    strongSelf.collectionView.reloadData()
                }
            })
        }else {
            
            cell.imgPhoto.image = UIImage.init(named: "camera-comment")
            cell.datelebtn.isHidden = true
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75,height: 83)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 23,
                                0, 15)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == dataImageArr.count{
            
                if let del = self.delegate {
                    del.pushImagePickerController(collectionViewTag: self.collectionView.tag)
                }
            
        }
        
    }
}
extension WOWPushCommentCell:UITextViewDelegate{
 
    func textViewDidEndEditing(_ textView: UITextView) {
        userCommentData?.comments = textView.text ?? ""
    }
}
