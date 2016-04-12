//
//  WOWSearchChildController.swift
//  Wow
//
//  Created by 小黑 on 16/4/7.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit
class WOWSearchChildController: UIViewController{
    @IBOutlet weak var tagListView: TagListView!
    let cellID = "WOWSearchCell"
    let searchItems = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initData(){
        
    }
    
    private func setUI(){
        //FIXME:测试
        let keyWords = ["本周特价","新年福袋","天天","分享甘甜的难得时光","上帝在细节中","Umbr","充满爱的设计"]
        tagListView.delegate = self
        tagListView.backgroundColor = MGRgb(245, g: 245, b: 245)
        tagListView.borderColor = BorderColor
        tagListView.borderWidth = 0.5
        for word in keyWords{
            tagListView.addTag(word)
        }
    }
    
}


extension WOWSearchChildController:TagListViewDelegate{
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        DLog("搜索内容:\(title)")
    }
}


/*
extension WOWSearchChildController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyWords.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! WOWSearchCell
        cell.titleLabel.text = keyWords[indexPath.item]
        cell.titleLabel.font = FontLevel005
        cell.titleLabel.borderRadius(18)
        borderColor(cell.titleLabel)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return calItemCellSize(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(15,15,15,15)
    }
    
    private func calItemCellSize(indexPath:NSIndexPath)->CGSize{
        let height:CGFloat = 36
        let stringSize = keyWords[indexPath.item].size(FontLevel005)
        if stringSize.width < 50 {
            return CGSizeMake(80,height)
        }
        return CGSizeMake(stringSize.width + 30,height)
    }
}
*/
