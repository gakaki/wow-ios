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
        collectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:String(describing: WOWImageCell()))
        attentionButton.setBackgroundImage(UIImage(named: "unAttentionBack"), for: UIControlState())
        attentionButton.setBackgroundImage(UIImage(named: "attentionedBack"), for: .selected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func attentionButtonClick(_ sender: UIButton) {
        if let del = delegate {
            del.attentionButtonClick()
        }
    }
}

extension WOWLikeListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //FIXME:假数据
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWImageCell()), for:indexPath) as! WOWImageCell
        cell.pictureImageView.image = UIImage(named:"testBrand")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //FIXME:需要改为标准的尺寸
        return CGSize(width: 130, height: 130)
    }
}
