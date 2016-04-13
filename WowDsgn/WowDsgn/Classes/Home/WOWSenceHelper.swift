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
            returnCell = cell
        case 3:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWSenceLikeCell),forIndexPath: indexPath) as! WOWSenceLikeCell
            cell.moreLikeButton.addTarget(self, action: #selector(moreLikeButtonClick), forControlEvents:.TouchUpInside)
            returnCell = cell
        case 4:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWCommentCell),forIndexPath: indexPath)as!WOWCommentCell
                cell.hideHeadImage()
            cell.commentLabel.text = "我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君我叫尖叫君尖叫君"
            
            returnCell = cell
        default:
            DLog("")
        }
        return returnCell
    }
    
    class func moreLikeButtonClick(){
        let likeVC = UIStoryboard.initialViewController("Home", identifier:String(WOWLikeListController))
        senceController.navigationController?.pushViewController(likeVC, animated: true)
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
            DLog("")
        }
        
        let headerView = WOWMenuTopView(frame:CGRectMake(0,0,tableView.width,36))
        headerView.rightButton.tag = section + 1001
        headerView.rightButton.setImage(UIImage(named: "next_arrow")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
        if section == 2 {
            //FIXME:
            headerView.leftLabel.text = "100件商品"
            //FIXME:应该要跳商品清单吧
            headerView.addAction({ 
                DLog("商品列表")
            })
        }else if section == 4{
            headerView.leftLabel.text = "100条评论"
            headerView.addAction({ 
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                senceController.navigationController?.pushViewController(vc, animated: true)
            })
        }
        return headerView
    }
    
    class func viewForFooterInSection(tableView:UITableView,section:Int) ->UIView?{
        if section == 4 {
            let footerView = WOWMenuTopView(frame:CGRectMake(0,0,tableView.width,36))
            footerView.leftLabel.text = "我要评论"
            footerView.rightButton.setImage(UIImage(named: "next_arrow")?.imageWithRenderingMode(.AlwaysOriginal), forState:.Normal)
            footerView.rightButton.userInteractionEnabled = false
            footerView.topLine.hidden = false
            footerView.bottomLine.hidden = false
            footerView.addAction({
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                senceController.navigationController?.pushViewController(vc, animated: true)
            })
            return footerView
        }
        return nil
    }
    
}
