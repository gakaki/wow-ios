

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
    static var shareImage      : UIImage?
    class func sectionsNumber() -> Int{
        return 5
    }
    
    class func rowsNumberInSection(_ section:Int) ->Int{
        switch section {
        case 4: //评论 暂时干掉
            if let count = sceneModel?.comments_count {
                return count > 5 ? 5 : count
            }
            return 0
        case 3: //喜欢的暂时干掉
            return 0
        default:
            return 1
        }
    }
    
    class func cellForRow(_ tableview:UITableView,indexPath:IndexPath) -> UITableViewCell{
        var returnCell:UITableViewCell!
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: WOWSenceImageCell.self), for:indexPath) as! WOWSenceImageCell
//            cell.contentImageView.kf_setImageWithURL(NSURL(string:sceneModel?.image ?? "")!, placeholderImage: UIImage(named: "placeholder_product"))
            
            cell.contentImageView.set_webimage_url(sceneModel?.image )

            self.shareImage = cell.contentImageView.image
            returnCell = cell
        case 1:
            let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: WOWAuthorCell.self), for:indexPath) as! WOWAuthorCell
            cell.desLabel.text = sceneModel?.desc
            cell.contentView.bringSubview(toFront: cell.desLabel)
            returnCell = cell
        case 2:
            let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: WOWSubArtCell.self),for: indexPath) as! WOWSubArtCell
            cell.dataArr = sceneModel?.products
            cell.delegate = WOWSenceHelper.senceController
            returnCell = cell
        case 3:
            let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: WOWSenceLikeCell.self),for: indexPath) as! WOWSenceLikeCell
            cell.rightTitleLabel.text = "xx 人喜欢"
            cell.rightBackView.addAction({
                let likeVC = UIStoryboard.initialViewController("Home", identifier:String(describing: WOWLikeListController.self))
                senceController.navigationController?.pushViewController(likeVC, animated: true)
            })
            returnCell = cell
        case 4:
            let cell = tableview.dequeueReusableCell(withIdentifier: String(describing: WOWCommentCell.self),for: indexPath)as!WOWCommentCell
//                cell.hideHeadImage()
            if let model = sceneModel?.comments?[(indexPath as NSIndexPath).row] {
                cell.commentLabel.text = model.comment
                cell.dateLabel.text    = model.created_at
                cell.nameLabel.text    = model.user_nick
            }
            returnCell = cell
        default:
           break
        }
        return returnCell
    }
        
    class func heightForHeaderInSection(_ section:Int) -> CGFloat{
        switch section {
        case 0,1,3:
            return 0.01
        case 4:
            if let count = sceneModel?.comments_count{
                return count == 0 ? 0.01 : 36
            }
            return 0.01
        default:
            return 44
        }
    }
    
    
    class func heightForFooterInSection(_ section:Int) ->CGFloat{
        switch section {
        case 4:
            return 44
        case 2:
            return 20
        default:
            return 0.01
        }
    }
    
    class func viewForHeaderInSection(_ tableView:UITableView,section:Int) -> UIView?{
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
            if let arr = sceneModel?.comments {
                if arr.count == 0 {
                    return nil
                }
                let headerView = WOWMenuTopView(leftTitle: "\(sceneModel?.comments_count ?? 0)条评论 ", rightHiden:false, topLineHiden: false, bottomLineHiden:false)
                headerView.addAction({
                    let vc = UIStoryboard.initialViewController("Home", identifier: String(describing: WOWCommentController.self)) as! WOWCommentController
                    vc.mainID = sceneModel?.id?.toInt()
                    vc.commentType = CommentType.sence
                    senceController.navigationController?.pushViewController(vc, animated: true)
                })
                return headerView
            }
            return nil
        }
        return nil
    }
    
   
    class func viewForFooterInSection(_ tableView:UITableView,section:Int) ->UIView?{
        if section == 4{
            let footerView = WOWMenuTopView(leftTitle: "我要评论", rightHiden: false, topLineHiden: false, bottomLineHiden: true)
            footerView.addAction({
                let vc = UIStoryboard.initialViewController("Home", identifier: String(describing: WOWCommentController.self)) as! WOWCommentController
                vc.mainID = sceneModel?.id?.toInt()
                vc.commentType = CommentType.sence
                senceController.navigationController?.pushViewController(vc, animated: true)
            })
            return footerView
        }
        return nil
    }
}
