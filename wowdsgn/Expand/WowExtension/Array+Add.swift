//
//  Array+Add.swift
//  wowdsgn
//
//  Created by 安永超 on 16/11/30.
//  Copyright © 2016年 g. All rights reserved.
//

import Foundation

extension Array{
    func formatArray(_ addStr: String) -> String {
        var formatStr = ""
        guard self.count > 0 else {
            return formatStr
        }
        for str in self.enumerated() {
            if str.offset == self.count - 1 {
                formatStr.append(str.element as! String)
            }else {
                formatStr.append(str.element as! String + addStr)
                
            }

        }
        return formatStr
    }
   

}
