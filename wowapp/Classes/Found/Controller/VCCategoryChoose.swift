
import UIKit

class VCCategoryChoose: VCBaseVCCategoryFound {

    class CVCell: UICollectionViewCell {
        
        let borderColor          = UIColor(hexString:"EAEAEA")

        var pictureImageView: UIImageView!
        var label_name:UILabel!
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        func setModel(m:WOWFoundCategoryModel){
//            label_name.text      = m.categoryName
//            print(label_name)
//            if let pic = m.productImg {
                pictureImageView.set_webimage_url(m.productImg)
                label_name.text      = m.categoryName
//            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor     = UIColor.whiteColor()
            

            pictureImageView    = UIImageView()
            label_name          = UILabel()
            
            self.addSubview(pictureImageView)
            self.addSubview(label_name)
            
            pictureImageView.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self.snp_top)
                make.width.equalTo(self.snp_width)
                make.height.equalTo(self.snp_width)
            }
            
            label_name.snp_makeConstraints { (make) -> Void in
                
                label_name.font             = UIFont.systemFontOfSize(12)
                label_name.textAlignment    = NSTextAlignment.Center
                
                make.width.equalTo(self.snp_width)
                make.height.equalTo(20)
                make.top.equalTo(pictureImageView.snp_bottom).offset(UIEdgeInsets.init(top: 1.w, left: 0, bottom: 0, right: 0))
                
            }
        }
    }
    class TvCell: UITableViewCell {
        
        var label_name              = UILabel()
        var line:UIView             = UIView()
        var v_black_r:UIView        = UIView()
        
        override init(style: UITableViewCellStyle,reuseIdentifier: String?){
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        override func setSelected(selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if ( selected == true){
                label_name.textColor  = UIColor.blackColor()
                v_black_r.hidden = false
            }else{
                label_name.textColor  = UIColor(hexString:"808080")
                v_black_r.hidden = true
            }
        }
        
        func setModel(m:WOWFoundCategoryModel)  {
            label_name.text = m.categoryName
        }
        
        func setUI() {
            
            //add label
            self.addSubview(label_name)
            //add line
            self.addSubview(line)
            self.addSubview(v_black_r)

            label_name.snp_makeConstraints { (make) -> Void in
                
                label_name.font             = UIFont.systemFontOfSize(14)
                label_name.textColor        = UIColor.blackColor()
                label_name.textAlignment    = NSTextAlignment.Center
                
                make.width.equalTo(self.snp_width)
                make.height.equalTo(15.h)
                make.center.equalTo(self.snp_center)
                
            }
            
            v_black_r.snp_makeConstraints { (make) -> Void in
                v_black_r.backgroundColor = UIColor.blackColor()
                make.width.equalTo(4.w)
                make.height.equalTo(18.w)
                make.right.equalTo(self.snp_right)
                make.centerY.equalTo(self.snp_centerY)
                v_black_r.hidden = true
            }

 
        }
    }
    
    //左侧和右侧数据
    var vo_categories_arr           = [WOWFoundCategoryModel]()
    var vo_categories_sub_arr       = [WOWFoundCategoryModel]()
    var cid                         = "0"
    let tv_width                    = 110.w
    
    
    var tv:UITableView!
    var cv:UICollectionView!

    func createTvLeft() {
        
        self.title           = "全部分类"
        tv                   = UITableView(frame:CGRectMake(0, 0 , self.tv_width, MGScreenHeight), style:.Plain)
        tv.separatorColor    = UIColor(hexString:"EAEAEA")
        tv.delegate          = self
        tv.dataSource        = self
        tv.registerClass(TvCell.self, forCellReuseIdentifier:String(TvCell))
//        tv.bounces           = false
        tv.showsVerticalScrollIndicator = false
        self.view.addSubview(tv)
    }
    
    
    func createCvRight()  {
    
        let cv_width                           = MGScreenWidth - self.tv_width
        let padding                            = CGFloat(15)
        let cell_width                         = (cv_width  - padding * 3) / 2
        let cell_height                        = cell_width + 1 + 30
        let frame                              = CGRectMake( self.tv_width, 0, cv_width, MGScreenHeight)
        
        let layout                             = UICollectionViewFlowLayout()
        layout.scrollDirection                 = .Vertical
        layout.sectionInset                    = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        
        layout.itemSize                        = CGSize(width:cell_width , height: cell_height)
//      layout.estimatedItemSize               = CGSize(width: cv_width / 2 - CGFloat(2), height: 100 )

        layout.minimumInteritemSpacing         = padding
        layout.minimumLineSpacing              = padding
        
        cv                                     = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.delegate                             = self
        cv.dataSource                           = self
        cv.backgroundColor                      = UIColor(hue:0.00, saturation:0.00, brightness:0.96, alpha:1.00)
        cv.backgroundView                       = UIView(frame:CGRectZero)
        
        
        cv.registerClass(CVCell.self, forCellWithReuseIdentifier:String(CVCell))
        cv.showsVerticalScrollIndicator         = false
        cv.showsHorizontalScrollIndicator       = false
//        cv.scrollEnabled                        = false
        
        cv.addBorderLeft(size: 0.3, color: UIColor(hexString:"EAEAEA")!)
//        cv.bounces                              = false
//        cv.pagingEnabled                        = true
//        cv.backgroundColor                      = UIColor.blackColor()
        self.view.addSubview(cv)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    
    override func setUI() {
        super.setUI()

        createTvLeft()
        createCvRight()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Network
    override func request() {
        
        super.request()
        
        WOWHud.showLoading()
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Category_subCategory_with_image(categoryId:cid), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{

                let r                             =  JSON(result)
                strongSelf.vo_categories_arr      =  Mapper<WOWFoundCategoryModel>().mapArray( r["categoryProductImgVoList"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.tv.reloadData()
                
                //默认选中第一个 触发collection变化
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                strongSelf.tv.selectRowAtIndexPath(  indexPath , animated: true, scrollPosition: UITableViewScrollPosition.Top)
                strongSelf.tableView(strongSelf.tv, didSelectRowAtIndexPath: indexPath)
                
            }
            
        }){ (errorMsg) in
            print(errorMsg)
            
            WOWHud.dismiss()

        }
    }
    
    func request_sub_cid(cid:String) {
    
        WOWHud.showLoading()

        WOWNetManager.sharedManager.requestWithTarget(RequestApi.Api_Category_subCategory_with_image(categoryId:cid), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                             =  JSON(result)
                


                strongSelf.vo_categories_sub_arr  =  Mapper<WOWFoundCategoryModel>().mapArray( r["categoryProductImgVoList"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.cv.reloadData()
                
             
                //默认选中第一个
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                strongSelf.cv.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
                strongSelf.cv.setContentOffset(CGPointZero, animated: false)

                WOWHud.dismiss()

            }
            
        }){ (errorMsg) in
            print(errorMsg)
            WOWHud.dismiss()

        }
    }

    
    
}

extension VCCategoryChoose:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return vo_categories_arr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCellWithIdentifier(String(TvCell), forIndexPath: indexPath) as! TvCell
        cell.selectionStyle     = .None
        let model               = vo_categories_arr[indexPath.section]
        cell.setModel(model)
        
        
        return cell
    }
  
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView( tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 60.w
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let m = vo_categories_arr[indexPath.section]

        if let cid = m.categoryID {
            request_sub_cid(cid.toString)
        }

    }
}

extension VCCategoryChoose:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let c = self.vo_categories_sub_arr.count
        return c
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCellWithReuseIdentifier(String(CVCell), forIndexPath: indexPath) as! CVCell
        let m               = vo_categories_sub_arr[indexPath.item]
        cell.setModel(m)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let m = vo_categories_sub_arr[indexPath.item]
        if let cid = m.categoryID , cname = m.categoryName{
                toVCCategory( cid ,cname: cname)
        }
 
    }
}
