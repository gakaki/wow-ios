//
//  WOWSearchLayout.swift
//  wowapp
//
//  Created by 安永超 on 16/9/21.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit


class WOWSearchLayout: UICollectionViewFlowLayout {
    override func prepare() {
        
        super.prepare()
        
        //cell数据离头距离
        self.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0)
        //每组头的大小
//        self.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 35)
//        self.footerReferenceSize = CGSize(width: MGScreenWidth, height: 35)
        self.minimumInteritemSpacing = 10
    }
    
    //这里就是返回每个cell，通过这里来调整位置
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
            let arrCell =  super.layoutAttributesForElements(in: rect)!
        if arrCell.count > 0 {
            for i in 1..<arrCell.count {
                
                //当前 UICollectionViewLayoutAttributes
                let currentLayout = arrCell[i]
                //上一个 UICollectionViewLayoutAttributes
                let prevLayout = arrCell[i - 1]
                if ((prevLayout.indexPath as NSIndexPath).section == (currentLayout.indexPath as NSIndexPath).section) {
                    //我们想设置的最大间距，可根据需要改
                    let maximumSpacing = 10
                    //前一个cell的最右边
                    let origin = prevLayout.frame.maxX
                    //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
                    //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
                    if((CGFloat(origin) + CGFloat(maximumSpacing) + currentLayout.frame.size.width) < self.collectionViewContentSize.width) {
                        var frame = currentLayout.frame
                        frame.origin.x = CGFloat(origin) + CGFloat(maximumSpacing)
                        currentLayout.frame = frame
                    }
                }
                
            }

        }
        return arrCell

        
    }

}
