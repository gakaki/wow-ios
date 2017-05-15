//
//  WOWPushCommentCell.swift
//  UpdatePhotoDemo
//
//  Created by 陈旭 on 2016/11/24.
//  Copyright © 2016年 陈旭. All rights reserved.
//

import UIKit
enum PushType {
    
    case ShopComment // 商品评论
    case FeebdBack  // 意见反馈
    case RefundReason // 退换货理由
}
protocol PushCommentDelegate:class {
    func pushImagePickerController(collectionViewTag: Int)
}
class WOWPushCommentCell: WOWStyleNoneCell,TZImagePickerControllerDelegate {
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var TopHightConstraint: NSLayoutConstraint! // 顶部View 高度

    
    @IBOutlet weak var textViewLeftConstraint: NSLayoutConstraint! // textView 距离左边距
    var cellType : PushType = .ShopComment{
        didSet{
            switch cellType {
            case .FeebdBack:
                topView.isHidden    = true
                TopHightConstraint.constant     = 0
            case .RefundReason:
                topView.isHidden                    = true
                TopHightConstraint.constant         = 40
                textViewLeftConstraint.constant     = 10
            default: break
            }
        }
    }
    
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    @IBOutlet weak var lbDes: UILabel!
    
    var itemWidth : CGFloat  = (MGScreenWidth - 23 - 15 - 15*4)/5
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
//    @IBOutlet weak var textView: HolderTextView!
    
    var dataImageArr = [UIImage](){
        didSet{
            collectionView.reloadData()
        }
    }
    var lbPlaceholder = "请写下您的购物体验和使用感受"
    var modelPhotosData               :    UserPhotoManage? // 记录当前cell上面选择的图片信息
    var userCommentData:    UserCommentManage?{// 用户评论信息 包含，评论内容，评论的图片信息
        didSet{
            if userCommentData?.comments == "" {
                inputTextView.placeholder   = lbPlaceholder
                inputTextView.text          = ""
            }else{
                inputTextView.placeholder   = ""
                inputTextView.text          = userCommentData?.comments ?? ""
            }
        
        }
       
    }
    weak var delegate                 :    PushCommentDelegate?
    
    var maxNumPhoto                 = 5 // 最多显示几个
    var collectionViewOfDataSource  = Dictionary<Int, [UIImage]>() //空字典
    
    var modelData : WOWProductPushCommentModel?{// 商品信息
        
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
                    strongSelf.userCommentData?.commentImgs.remove(at: indexPath.row)// 用户选择image 的Url数组
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
        return CGSize(width: 82,height: 82)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0,
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
    
    fileprivate func limitTextLength(_ textView: UITextView){
        
        let toBeString = textView.text as NSString
        
        if (toBeString.length > 140) {
            numberLabel.colorWithText(toBeString.length.toString, str2: "/140", str1Color: UIColor.red)
            
        }else {
            numberLabel.text = String(format: "%i/140", toBeString.length)
        }
        userCommentData?.commentsLength = toBeString.length// 记录字数
        userCommentData?.comments       = toBeString as String // 记录评论内容
    }
    //    //中文和其他字符的判断方式不一样
    func textViewDidChange(_ textView: UITextView) {

        let language = textView.textInputMode?.primaryLanguage
        //        FLOG("language:\(language)")
        if let lang = language {
            if lang == "zh-Hans" ||  lang == "zh-Hant" || lang == "ja-JP"{ //如果是中文简体,或者繁体输入,或者是日文这种带默认带高亮的输入法
                let selectedRange = textView.markedTextRange
                var position : UITextPosition?
                if let range = selectedRange {
                    position = textView.position(from: range.start, offset: 0)
                }
                //系统默认中文输入法会导致英文高亮部分进入输入统计，对输入完成的时候进行字数统计
                if position == nil {
                    //                    FLOG("没有高亮，输入完毕")
                    limitTextLength(textView)
                }
            }else{//非中文输入法
                limitTextLength(textView)
            }
        }else {
            limitTextLength(textView)
        }
        
    }
}
