//
//  WOWLikeListCell.swift
//  Wow
//
//  Created by 王云鹏 on 16/3/21.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

protocol SenceListCellDelegate:class{
    func attentionButtonClick();
}

class WOWLikeListCell: UITableViewCell {
    weak var delegate:SenceListCellDelegate?
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var attentionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:String(WOWImageCell))
        attentionButton.setBackgroundImage(UIImage(named: "unAttentionBack"), forState: .Normal)
        attentionButton.setBackgroundImage(UIImage(named: "attentionedBack"), forState: .Selected)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func attentionButtonClick(sender: UIButton) {
        if let del = delegate {
            del.attentionButtonClick()
        }
    }
}

extension WOWLikeListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //FIXME:假数据
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(WOWImageCell), forIndexPath:indexPath) as! WOWImageCell
        cell.pictureImageView.image = UIImage(named:"testBrand")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //FIXME:需要改为标准的尺寸
        return CGSizeMake(130, 130)
    }
}
