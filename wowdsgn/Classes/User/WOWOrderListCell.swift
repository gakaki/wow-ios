//
//  WOWOrderListCell.swift
//  WowDsgn
//
//  Created by 小黑 on 16/4/16.
//  Copyright © 2016年 王云鹏. All rights reserved.
//

import UIKit

enum OrderCellAction {
    case showTrans
    case pay
    case comment
    case sureReceive
    case delete
}

protocol OrderCellDelegate:class{
    func  OrderCellClick(_ type:OrderCellAction,model:WOWNewOrderListModel,cell:WOWOrderListCell)
    
    func clickGoToDetail(orderCoder: String)
}

class WOWOrderListCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel! // 订单状态
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var orderIdLabel: UILabel! // 订单ID
    @IBOutlet weak var goodsCountLabel: UILabel! // 共多少件
    @IBOutlet weak var totalPriceLabel: UILabel! // 合计多少钱
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var rightViseButton: UIButton!
    
    //单个的
    @IBOutlet weak var singleBackView: UIView!
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var singleNameLabel: UILabel!
    @IBOutlet weak var singleTypeLabel: UILabel!
    
    weak var delegate : OrderCellDelegate?
//    var model : WOWOrderListModel?
     var modelNew : WOWNewOrderListModel?
    let statuTitles = ["待付款","待发货","待收货","待评论","已完成","已关闭"]
    let rightTitles = ["立即支付","","确认收货","评价","删除订单",""]
    var dataArr = [WOWOrderProductModel] ()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetSeparators()
        collectionView.register(WOWImageCell.self, forCellWithReuseIdentifier:"WOWImageCell")
        collectionView.addTapGesture (action: {[weak self] (tap) in
            
            if let strongSelf = self {
               print("你点击了")
                strongSelf.delegate?.clickGoToDetail(orderCoder: strongSelf.orderIdLabel.text ?? "")
            }
            
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func showData(_ m:WOWNewOrderListModel){
        modelNew = m
        
        switch m.orderStatus ?? 0 {
        case 4,5,6:
            statusLabel.textColor = UIColor.init(hexString: "000000")
            rightButton.isHidden = true
        case 0:
            rightButton.isHidden = false
            rightButton.setTitle("立即支付", for: UIControlState())
            statusLabel.textColor = UIColor.init(hexString: "FE3824")
        case 3:
            rightButton.isHidden = false
            rightButton.setTitle("确认收货", for: UIControlState())
            statusLabel.textColor = UIColor.init(hexString: "FE3824")
        default:
            rightButton.isHidden = true
            statusLabel.textColor = UIColor.init(hexString: "FE3824")
        }

        
        
        statusLabel.text = m.orderStatusName
        orderIdLabel.text = m.orderCode
        goodsCountLabel.text = "共"+(m.totalProductQty?.toString)!+"件"
        let result = WOWCalPrice.calTotalPrice([m.orderAmount ?? 0],counts:[1])
        
        totalPriceLabel.text = result
        rightViseButton.isHidden = true
        collectionView.reloadData()
    }
    
    @IBAction func rightButtonClick(_ sender: UIButton) {
        if sender.tag == 1001 {
            if let del = delegate {
                del.OrderCellClick(.showTrans,model:self.modelNew!,cell: self)
            }
        }else{
            var action = OrderCellAction.pay
            switch modelNew?.orderStatus ?? 2{
            case 0: //待付款
                action = .pay
            case 2: //部分收货
                action = .sureReceive
            case 3: //待收货
                action = .sureReceive
            case 4: //已完成 // 待评论
                action = .comment
            default:
                break
            }
            if let del = delegate {
                del.OrderCellClick(action,model: self.modelNew!,cell:self)
            }
        }
    }
    
//    private func configShowStatus( status:Int){
//        let orderStatus = status > 5 ? 5:status
//        rightButton.setTitle(rightTitles[orderStatus], forState: .Normal)
//        statusLabel.text = statuTitles[orderStatus]
//        rightViseButton.hidden = true
//        rightButton.hidden = false
//        rightButton.backgroundColor = ThemeColor
//        rightButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
//        rightViseButton.hidden = true //先暂时把查看物流干掉吧
//        WOWBorderColor(rightButton)
//        switch orderStatus {
//        case 0: //待付款
//            statusLabel.textColor = UIColor.redColor()
//        case 1: //待发货
//            rightButton.hidden = true
//            statusLabel.text = "待发货"
//            statusLabel.textColor = UIColor.orangeColor()
//        case 2: //待收货 查看物流
//            statusLabel.textColor = MGRgb(255, g: 150, b: 0)
////            rightViseButton.hidden = false
//            rightViseButton.borderColor(0.5, borderColor:UIColor.blackColor())
//            rightViseButton.setTitleColor(UIColor.blackColor(), forState:.Normal)
//            rightViseButton.setTitle("查看物流", forState: .Normal)
//        case 3: //待评价
//            statusLabel.textColor = MGRgb(0, g: 118, b: 255)
//        case 4: //已完成
//            statusLabel.textColor = UIColor.blackColor()
//            rightButton.borderColor(0.5, borderColor:UIColor.redColor())
//            rightButton.backgroundColor = UIColor.whiteColor()
//            rightButton.setTitleColor(UIColor.redColor(), forState:.Normal)
//        case 5: //已关闭 单子过期没支付
//            statusLabel.textColor = UIColor.blackColor()
//            rightButton.hidden = true
//        default:
//            break
//        }
//    }
    
}

extension WOWOrderListCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelNew?.productSpecImgs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WOWImageCell", for: indexPath) as! WOWImageCell
//        let model = dataArr[indexPath.row]
//        DLog((modelNew?.productSpecImgs[indexPath.row])!)
//        cell.pictureImageView.kf_setImageWithURL(URL(string: (modelNew?.productSpecImgs[indexPath.row])!)!, placeholderImage: UIImage(named: "placeholder_product"))
        
        let url = modelNew?.productSpecImgs[indexPath.row]
        cell.pictureImageView.set_webimage_url(url)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 15, 10, 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.clickGoToDetail(orderCoder: orderIdLabel.text ?? "")
        
    }
}
