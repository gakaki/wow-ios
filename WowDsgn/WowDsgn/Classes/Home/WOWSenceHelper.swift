//
//  WOWSenceCellManager.swift
//  Wow
//
//  Created by wyp on 16/4/5.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSenceHelper: NSObject {
    static var senceController : WOWSenceController!
    static var sceneModel      : WOWSenceModel?
    class func sectionsNumber() -> Int{
        return 5
    }
    
    class func rowsNumberInSection(section:Int) ->Int{
        switch section {
        case 4: //评论 暂时干掉
            return 0
        case 3: //喜欢的暂时干掉
            return 0
        default:
            return 1
        }
    }
    
    class func cellForRow(tableview:UITableView,indexPath:NSIndexPath) -> UITableViewCell{
        var returnCell:UITableViewCell!
        switch indexPath.section {
        case 0:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWSenceImageCell), forIndexPath:indexPath) as! WOWSenceImageCell
            cell.contentImageView.kf_setImageWithURL(NSURL(string:sceneModel?.image ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
            returnCell = cell
        case 1:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWAuthorCell), forIndexPath:indexPath) as! WOWAuthorCell
            cell.desLabel.text = sceneModel?.desc
            cell.contentView.bringSubviewToFront(cell.desLabel)
            returnCell = cell
        case 2:
            let cell = tableview.dequeueReusableCellWithIdentifier(String(WOWSubArtCell),forIndexPath: indexPath) as! WOWSubArtCell
            cell.dataArr = sceneModel?.products
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
        if section == 4 { //评论暂时干掉
            return 0.01
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
            headerView.leftLabel.text = "\(sceneModel?.products?.count ?? 0)件商品"
            return headerView
        }else if section == 4{
            /*
            let headerView = WOWMenuTopView(leftTitle: "xx条评论 ", rightHiden:false, topLineHiden: true, bottomLineHiden:true)
            headerView.addAction({ 
                let vc = UIStoryboard.initialViewController("Home", identifier: String(WOWCommentController)) as! WOWCommentController
                senceController.navigationController?.pushViewController(vc, animated: true)
            })
            return headerView
             */
            return nil
        }
        return nil
    }
    
    /*
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
    */
}
