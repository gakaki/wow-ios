//
//  WOWSenceController.swift
//  Wow
//
//  Created by wyp on 16/4/5.
//  Copyright © 2016年 wowdsgn. All rights reserved.
//

import UIKit

class WOWSenceController: WOWBaseViewController {
    var footerCollectionView:UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit{
        footerCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func setUI() {
        super.setUI()
        navigationItem.title = "场景"
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib.nibName(String(WOWSenceImageCell)), forCellReuseIdentifier:String(WOWSenceImageCell))
        tableView.registerNib(UINib.nibName(String(WOWCommentCell)), forCellReuseIdentifier:String(WOWCommentCell))
        tableView.registerNib(UINib.nibName(String(WOWSubArtCell)), forCellReuseIdentifier:String(WOWSubArtCell))
        tableView.registerNib(UINib.nibName(String(WOWSenceLikeCell)), forCellReuseIdentifier:String(WOWSenceLikeCell))

        WOWSenceHelper.senceController = self
        configTableFooterView()
    }

    @IBAction func backButtonClick(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func configTableFooterView(){
        let space:CGFloat = 4
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake((MGScreenWidth - space * 3)/2,(MGScreenWidth - space)/2)
        layout.headerReferenceSize = CGSizeMake(MGScreenWidth,50);  //设置head大小
        layout.footerReferenceSize = CGSizeMake(MGScreenWidth,50);
        layout.minimumInteritemSpacing = space;
        layout.minimumLineSpacing = space;
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space)
        layout.scrollDirection = .Vertical
        footerCollectionView = UICollectionView(frame:MGFrame(0, y: 0, width: MGScreenWidth, height: 0), collectionViewLayout: layout)
        footerCollectionView.backgroundColor = UIColor.whiteColor()
        footerCollectionView.registerClass(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier:"WOWCollectionHeaderCell")
         footerCollectionView.registerClass(WOWReuseSectionView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionFooter, withReuseIdentifier:"WOWCollectionFooterCell")
        footerCollectionView.registerClass(WOWImageCell.self, forCellWithReuseIdentifier:String(WOWImageCell))
        footerCollectionView.delegate = self
        footerCollectionView.dataSource = self
        tableView.tableFooterView = footerCollectionView
        footerCollectionView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.Old, context:nil)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let height = self.footerCollectionView.collectionViewLayout.collectionViewContentSize().height
        guard height != footerCollectionView.size.height else{
            return
        }
        DLog("\(height)")
        footerCollectionView.size = CGSizeMake(MGScreenWidth, height)
        tableView.tableFooterView = footerCollectionView
    }
    
}


extension WOWSenceController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("WOWImageCell", forIndexPath: indexPath) as! WOWImageCell
        cell.pictureImageView.image = UIImage(named: "testBrand")
        WOWBorderColor(cell.pictureImageView)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var returnView:UICollectionReusableView!
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "WOWCollectionHeaderCell", forIndexPath: indexPath) as! WOWReuseSectionView
            view.titleLabel.text = "猜你喜欢"
            returnView = view
        }
        if kind == UICollectionElementKindSectionFooter{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "WOWCollectionFooterCell", forIndexPath: indexPath) as!  WOWReuseSectionView
            view.titleLabel.text = ""
            returnView = view
        }
        return returnView
    }
}


extension WOWSenceController:UITableViewDelegate,UITableViewDataSource{
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return WOWSenceHelper.sectionsNumber()
     }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WOWSenceHelper.rowsNumberInSection(section)
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return WOWSenceHelper.cellForRow(tableView, indexPath: indexPath)
    }
    
     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return WOWSenceHelper.heightForHeaderInSection(section)
    }
    
     func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return WOWSenceHelper.viewForHeaderInSection(tableView, section: section)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return WOWSenceHelper.heightForFooterInSection(section)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return WOWSenceHelper.viewForFooterInSection(tableView, section: section)
    }
    
}
