//
//  WOWSenceCellManager.swift
//  Wow
//
//  Created by wyp on 16/4/5.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSenceHelper: NSObject {
    static var senceController:WOWSenceController!
    class func sectionsNumber() -> Int{
        return 5
    }
    
    class func rowsNumberInSection(section:Int) ->Int{
        switch section {
        case 4:
            return 5
        default:
            return 1
        }
    }
    
    class func cellForRow(tableview:UITableView,indexPath:NSIndexPath) -> UITableViewCell{
        var returnCell:UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWSenceImageCell), forIndexPath:indexPath) as! WOWSenceImageCell
            //FIXME:测试数据
            cell.contentImageView.image = UIImage(named:"testPic")
            returnCell = cell
        case 1:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWAuthorCell), forIndexPath:indexPath) as! WOWAuthorCell
            //FIXME:测试数据
            cell.desLabel.text = "尖叫设计君君"
            cell.contentView.bringSubviewToFront(cell.desLabel)
            returnCell = cell
        case 2:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWSubArtCell),forIndexPath: indexPath) as! WOWSubArtCell
            cell.delegate = WOWSenceHelper.senceController
            returnCell = cell
        case 3:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWSenceLikeCell),forIndexPath: indexPath) as! WOWSenceLikeCell
            cell.rightTitleLabel.text = "xx 人喜欢"
            cell.rightBackView.addAction({
                let likeVC = UIStoryboard.initialViewController("Home", identifier:String(WOWLikeListController))
                senceController.navigationController?.pushViewController(likeVC, animated: true)
            })
            returnCell = cell
        case 4:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWCommentCell),forIndexPath: indexPath)as!WOWCommentCell
                cell.hideHeadImage()
            cell.commentLabel.text = "我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君"
            returnCell = cell
        default:
           break
        }
        return returnCell
    }
        
    class func heightForHeaderInSection(section:Int) -> CGFloat{
        switch section {
        case 0,1,3:
            return 0.01
        default:
            return 36
        }
    }
    
    
    class func heightForFooterInSection(section:Int) ->CGFloat{
        if section == 4 {
            return 44
        }else{
            return 0.01
        }
    }
    
    class func viewForHeaderInSection(tableView:UITableView,section:Int) -> UIView?{
        switch section {
        case 0,1,3:
            return nil
        default:
            break
        }
        
        if section == 2 {
            let headerView = WOWMenuTopView(leftTitle: "xx件商品", rightHiden: true, topLineHiden: true, bottomLineHiden:true)
            //FIXME:
            headerView.leftLabel.text = "100件商品"
            return headerView
        }else if section == 4{
            let headerView = WOWMenuTopView(leftTitle: "xx条评论 ", rightHiden:false, topLineHiden: true, bottomLineHiden:true)
            headerView.addAction({ 
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                senceController.navigationController?.pushViewController(vc, animated: true)
            })
            return headerView
        }
        return nil
    }
    
    class func viewForFooterInSection(tableView:UITableView,section:Int) ->UIView?{
        if section == 4 {
            let footerView = WOWMenuTopView(leftTitle: "我要评论", rightHiden: false, topLineHiden: false, bottomLineHiden: false)
            footerView.addAction({
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                senceController.navigationController?.pushViewController(vc, animated: true)
            })
            return footerView
        }
        return nil
    }
    
}
