//
//  WOWPraiseOneCell.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/28.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWPraiseOneCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var v_height: NSLayoutConstraint!
    
    var dataArr = [WOWStatisticsModel]()
    
    let CellID: String = String(describing: WOWWorksCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        v_height.constant = (MGScreenWidth - 12)/3
        configCollectionView()
    }
    
    func configCollectionView() {
        collectionView.delegate     = self
        collectionView.dataSource   = self

        collectionView.showsHorizontalScrollIndicator      = false
        collectionView.register(UINib.nibName(CellID), forCellWithReuseIdentifier:CellID)

        let layout                          = UICollectionViewFlowLayout()
        layout.scrollDirection              = .horizontal
        layout.sectionInset                 = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.minimumLineSpacing           = 15.0
        collectionView.collectionViewLayout            = layout
    }
    
    func showData(model: WOWWorksListModel?) {
        if let model = model {
            imgView.set_webimage_url(model.pic)
            numLabel.text = String(format: "%i", model.likeCounts ?? 0)
            dataArr = model.userList ?? [WOWStatisticsModel]()
            if dataArr.count > 0 {
                collectionView.reloadData()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension WOWPraiseOneCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: 36.w,height: 36.w)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count > 5 ? 5 : dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! WOWWorksCell
        cell.imageView.borderRadius(18.w)
        let model = dataArr[indexPath.row]
        cell.imageView.set_webimage_url(model.avatar)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        VCRedirect.goOtherCenter(endUserId: model.endUserId ?? 0)
    }
}
