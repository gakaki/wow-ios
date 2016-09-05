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
}
