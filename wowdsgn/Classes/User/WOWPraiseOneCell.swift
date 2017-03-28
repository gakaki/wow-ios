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
    
    let CellID: String = String(describing: WOWWorksCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! WOWWorksCell
        
        return cell
    }

}
