//
//  WOWCustomKoloda.swift
//  wowdsgn
//
//  Created by 安永超 on 17/3/25.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit

class WOWCustomKoloda: UIView {
    @IBOutlet weak var workImg: UIImageView!
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var markImg: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowOffset = CGSize(width: 0, height: 2)  //设置图层阴影的偏移量
        self.layer.shadowOpacity = 0.1  //将图层阴影的不透明度设为 0.7
        self.layer.shadowRadius = 4 //将图层阴影的范围设为 5
        self.layer.shadowColor = UIColor.black.cgColor      //设置图层阴影的颜色
        self.backgroundColor = UIColor.white
        
        headImg.borderRadius(20)
        let borColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        headImg.borderColor(1, borderColor: borColor)
        // Initialization code
    }
    
    func showData(works: WOWFineWroksModel) {
        
        workImg.set_webimage_url(works.pic) //作品图片
        headImg.set_webimage_url_user(works.avatar)  //作者头像
        headImg.addTapGesture { (tap) in        //增加头像点击事件
            VCRedirect.goOtherCenter(endUserId: works.endUserId ?? 0)
        }
        userName.text = works.nickName  //作者昵称

        if let constellation = works.constellation {    //星座
            startLabel.text = WOWConstellation[constellation]
        }else {
            startLabel.text = ""
        }
        //通过判断性别区别view的背景颜色
        switch works.sex ?? 3{
        case 1:     //蓝色
            sexLabel.backgroundColor = UIColor.init(hexString: "#70B7FF")
        case 2:     //红色
            sexLabel.backgroundColor = UIColor.init(hexString: "FF8DBC")
        default:        //灰色
            sexLabel.backgroundColor = UIColor.init(hexString: "#808080")
        }

        if let ageRange = works.ageRange {  //年龄段
            sexLabel.text = WOWAgeRange[ageRange]
        }else {
            sexLabel.text = "保密"
        }
        
        if works.des == ""{     //作品描述
            markImg.isHidden = true
            descLabel.text = ""
            backImg.isHidden = true
        }else {
            markImg.isHidden = false
            descLabel.text = works.des
            backImg.isHidden = false
        }
    }

}
