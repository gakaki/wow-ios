//
//  WOWSearchFlowLayout.swift
//  wowapp
//
//  Created by 安永超 on 16/9/5.
//  Copyright © 2016年 小黑. All rights reserved.
//

import UIKit

class WOWSearchFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let layoutAttribute = super.layoutAttributesForItemAtIndexPath(indexPath)
        if layoutAttribute?.frame.origin.x == self.sectionInset.left {
            return layoutAttribute
        }
        
        let previoysIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
        
        let previousLayoutAttribute = self.layoutAttributesForItemAtIndexPath(previoysIndexPath)
        var frame = layoutAttribute?.frame
        frame?.origin.x = CGRectGetMaxX((previousLayoutAttribute?.frame)!) + 10
        layoutAttribute?.frame = frame!
        return layoutAttribute
    }
//    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let attributes = super.layoutAttributesForElementsInRect(rect)
//        
//        for var i = 1; i < attributes?.count; i += 1{
//            let currentLayoutAttributes = attributes![i]
//            let prevLayoutAttributes = attributes![i - 1]
//            
//            if (prevLayoutAttributes.indexPath.section == currentLayoutAttributes.indexPath.section) {
//                //我们想设置的最大间距，可根据需要改
//                
//                let maximumSpacing: CGFloat = 15
//                //前一个cell的最右边
//                let origin = CGRectGetMaxX(prevLayoutAttributes.frame)
//                //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//                //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//                if((origin + maximumSpacing + currentLayoutAttributes.frame.size.width) < self.collectionViewContentSize().width) {
//                    var frame = currentLayoutAttributes.frame
//                    frame.origin.x = origin + maximumSpacing
//                    currentLayoutAttributes.frame = frame
//                }
//            }
//
//        }
//        return attributes
//
//    }
}
