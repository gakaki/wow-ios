//
//  WOWProductCommentCell.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/24.
//  Copyright © 2016年 g. All rights reserved.
//

import UIKit
protocol WOWProductCommentCellDelegate:class{
    func lookBigImage(_ index: Int, array imgArr: Array<String>)
}

class WOWProductCommentCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
    var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 60 - 4 * 8 - 15) / 5
        }
    }
    @IBOutlet weak var headImg: UIImageView!        //用户头像
    @IBOutlet weak var nameLabel: UILabel!          //用户昵称
    @IBOutlet weak var timeLabel: UILabel!          //评论时间
    @IBOutlet weak var contentLabel: UILabel!       //评论内容
    @IBOutlet weak var specLabel: UILabel!          //商品规格信息
    @IBOutlet weak var collectionView: UICollectionView!    //图片视图
    @IBOutlet weak var replyLabel: UILabel!              //客服回复
    @IBOutlet weak var replyView: UIView!                //客服回复底层view
    @IBOutlet weak var replyBottom: NSLayoutConstraint!     //客服回复底层view的高度
    @IBOutlet weak var topHeight: NSLayoutConstraint!       //客服回复与view上的间隙
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!    //collectionview的高
    var imgArray = [String]()
    weak var delegate: WOWProductCommentCellDelegate?
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 5
        l.minimumColumnSpacing = 8
        l.minimumInteritemSpacing = 0
        l.sectionInset = UIEdgeInsetsMake(0, 0, 8, 0)
    
        return l
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func showData(model: WOWProductCommentModel?)  {
        if let model = model {
            //判断评论中是否有图片。如果有图片的话就初始化collectionview。
            let count = model.commentImgs?.count
            if count > 0 {
                configCollectionView()
                //动态改变collectionview的高度
                collectionHeight.constant = itemWidth + 8
                
                imgArray = WOWArrayAddStr.strAddJPG(array: model.commentImgs ?? [String]())
                collectionView.reloadData()
            }else {
                collectionHeight.constant = 0
            }
            headImg.setCornerRadius(radius: 15)
            headImg.set_webUserPhotoimage_url(model.avatar)
            nameLabel.text = model.nickName
            //格式化时间
            timeLabel.text = model.publishTimeFormat?.stringToTimeStamp()
            contentLabel.text = model.comments
            //每个规格之间增加一个字符的间隔
            if let array = model.specAttributes {
                    specLabel.text = array.formatArray("  ")
            }
            //是否有回复,如果没有回复需要修改下几个约束
            if model.isReplyed ?? false {
                topHeight.constant = 5
                replyBottom.constant = 15
                replyView.isHidden = false
                replyLabel.fontWithText("尖叫君：", str2: model.replyContent ?? "", font: UIFont.boldSystemFont(ofSize: 12))
            }else {
                topHeight.constant = 0
                replyBottom.constant = 0
                replyView.isHidden = true
                replyLabel.text = ""
            }
            
            
        }
    }
    func configCollectionView(){
       collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = self.layout
        collectionView.register(UINib.nibName(String(describing: WOWCommentImageCell.self)), forCellWithReuseIdentifier:String(describing: WOWCommentImageCell.self))
        
    }
    //delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWCommentImageCell.self), for: indexPath) as! WOWCommentImageCell
        cell.image.set_webimage_url(imgArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {
            del.lookBigImage(indexPath.row, array: imgArray)
        }
    }
    
    //water delegate
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth,height: itemWidth)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
