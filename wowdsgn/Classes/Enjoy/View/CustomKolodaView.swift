//
//  CustomKolodaView.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/24.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
import Koloda
private let defaultBackgroundCardsTopMargin: CGFloat = 6.0
private let defaultBackgroundCardsScalePercent: CGFloat = 0.9

class CustomKolodaView: KolodaView {

    override func frameForCard(at index: Int) -> CGRect {
        let bottomOffset: CGFloat = 0
        let topOffset = defaultBackgroundCardsTopMargin * CGFloat(countOfVisibleCards - 1)
        let scalePercent = defaultBackgroundCardsScalePercent
        let width = self.frame.width * pow(scalePercent, CGFloat(index))
        let xOffset = (self.frame.width - width) / 2
        let height = (self.frame.height - bottomOffset - topOffset) * pow(scalePercent, CGFloat(index))
        let multiplier: CGFloat = index > 0 ? 1.0 : 0.0
        let prevCardFrame = index > 0 ? frameForCard(at: max(index - 1, 0)) : .zero
        let yOffset = (prevCardFrame.height - height + prevCardFrame.origin.y + defaultBackgroundCardsTopMargin) * multiplier
        let frame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        
        return frame
    }

}
