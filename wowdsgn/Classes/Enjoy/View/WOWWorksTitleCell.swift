//
//  WOWWorksTitleCell.swift
//  wowdsgn
//
//  Created by 安永超 on 2017/5/2.
//  Copyright © 2017年 g. All rights reserved.
//

import UIKit
protocol WOWWorksTitleCellDelegate: class {
    func sortType(sort: Int)
}

class WOWWorksTitleCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var topicImg: UIImageView!
    @IBOutlet weak var picNumLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var picHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortHeadView: UIView!
    @IBOutlet weak var sortBtn: UIButton!       //排序
    @IBOutlet weak var moreBtnH: NSLayoutConstraint!    //了解更多高度
    @IBOutlet weak var moreBtnBottom: NSLayoutConstraint!   //了解更多距底部高度
    weak var delegate: WOWWorksTitleCellDelegate?
    
    var topicId = 0
    var itemWidth:CGFloat{
        get{
            return ( MGScreenWidth - 9) / 2
        }
    }
    var dataArr  = [WOWWorksListModel]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    lazy var layout:CollectionViewWaterfallLayout = {
        let l = CollectionViewWaterfallLayout()
        l.columnCount = 2
        l.minimumColumnSpacing = 3
        l.minimumInteritemSpacing = 3
        l.sectionInset = UIEdgeInsetsMake(3, 3, 0, 3)
        return l
    }()
    
    lazy var sortView:WOWSortView = {
        let v = Bundle.main.loadNibNamed(String(describing: WOWSortView.self), owner: self, options: nil)?.last as! WOWSortView
        v.newView.addTapGesture(target: self, action: #selector(newClick))
        v.hotView.addTapGesture(target: self, action: #selector(hotClick))
        
        return v
    }()
    
    lazy var backView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.addTapGesture(target: self, action: #selector(hidenSortView))
        return v
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configCollectionView()
    }
    
    func showData(topic: WOWActivityModel?, array dataArray: [WOWWorksListModel], lineN lineNum: Int) {
        if let model = topic {
            if lineNum < 4 {
                moreBtn.isHidden = true
                moreBtnH.constant = 0
                moreBtnBottom.constant = 0
            }else {
                moreBtn.isHidden = false
                moreBtnH.constant = 24
                moreBtnBottom.constant = 20

            }
            topicId = model.id ?? 0
            topicImg.set_webimage_url(model.img)
            picHeight.constant = model.picHeight
            picNumLabel.text = String(format: "%i", model.instagramQty ?? 0)
            switch model.status ?? 0 {
            case 0:
                timeLabel.text = String(format: "距离活动开始还有%i天", model.offset ?? 0)
            case 1:
                timeLabel.text = String(format: "距离活动结束还有%i天", model.offset ?? 0)
            case 2:
                timeLabel.text = "活动已结束"

            default:
                timeLabel.text = String(format: "距离活动开始还有%i天", model.offset ?? 0)

            }
            titleLabel.text = model.subhead
            contentLabel.text = model.content
            
        }
        dataArr = dataArray
    }

    
    @IBAction func sortAction(sender: UIButton) {
        showSortView()
    }
    
    @IBAction func moreAction(sender: UIButton) {
        VCRedirect.goWorksActivityDetail(topicId: topicId)
    }
    
    fileprivate func configCollectionView(){
        collectionView.collectionViewLayout = self.layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.emptyDataSetDelegate = self
        collectionView.emptyDataSetSource = self
        collectionView.register(UINib.nibName(String(describing: WOWWorksCell.self)), forCellWithReuseIdentifier:String(describing: WOWWorksCell.self))
        collectionView.isScrollEnabled = false
    }
    
    //显示视图+
    func showSortView() {
        addSubview(backView)
        backView.snp.makeConstraints {[unowned self] (make) in
            make.size.equalTo(self)
        }
        addSubview(sortView)
        sortView.snp.makeConstraints {[unowned self] (make) in
            make.width.equalTo(150)
            make.height.equalTo(76)
            make.top.equalTo(self.sortHeadView.snp.top).offset(43)
            make.right.equalTo(self.snp.right).offset(-8)
        }
    }
    //隐藏视图
    func hidenSortView() {
        sortView.removeFromSuperview()
        backView.removeFromSuperview()
    }
    
    //最新排序
    func newClick()  {
        sortBtn.setTitle("最新", for: .normal)
        sortView.hot_gou.isHidden = true
        sortView.new_gou.isHidden = false
        hidenSortView()
        if let del = delegate {
            del.sortType(sort: 0)
        }
    }
    
    //最热排序
    func hotClick() {
        sortBtn.setTitle("最热", for: .normal)
        sortView.hot_gou.isHidden = false
        sortView.new_gou.isHidden = true
        hidenSortView()
        if let del = delegate {
            del.sortType(sort: 1)
        }
    }
    

    //MARK: -- collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: WOWWorksCell.self), for: indexPath) as! WOWWorksCell
        let model = dataArr[(indexPath as NSIndexPath).row]
        
        cell.showData(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[(indexPath as NSIndexPath).row]
        VCRedirect.bingWorksDetails(worksId: model.id ?? 0)
        
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
//MARK: Delegate
extension WOWWorksTitleCell:CollectionViewWaterfallLayoutDelegate, DZNEmptyDataSetDelegate,DZNEmptyDataSetSource{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth,height: itemWidth)
    }
    //MARK: - DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let view = Bundle.main.loadNibNamed(String(describing: WOWWorkdEmptyView.self), owner: self, options: nil)?.last as! WOWWorkdEmptyView
        view.lbEmpty.text = "还没有发布任何内容"
        return view
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
