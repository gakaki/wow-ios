

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
        
        func setModel(_ m:WOWFoundCategoryModel){
//            label_name.text      = m.categoryName
//            print(label_name)
//            if let pic = m.productImg {
                pictureImageView.set_webimage_url(m.productImg)
                label_name.text      = m.categoryName
//            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor     = UIColor.white
            

            pictureImageView    = UIImageView()
            label_name          = UILabel()
            
            self.addSubview(pictureImageView)
            self.addSubview(label_name)
            
            pictureImageView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.snp.top)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(self.snp.width)
            }
            
            label_name.snp.makeConstraints { (make) -> Void in
                
                label_name.font             = UIFont.systemFont(ofSize: 12)
                label_name.textAlignment    = NSTextAlignment.center
                
                make.width.equalTo(self.snp.width)
                make.height.equalTo(20)
                make.top.equalTo(pictureImageView.snp.bottom).offset(1)
                
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
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            if ( selected == true){
                label_name.textColor  = UIColor.black
                v_black_r.isHidden = false
            }else{
                label_name.textColor  = UIColor(hexString:"808080")
                v_black_r.isHidden = true
            }
        }
        
        func setModel(_ m:WOWFoundCategoryModel)  {
            label_name.text = m.categoryName
        }
        
        func setUI() {
            
            //add label
            self.addSubview(label_name)
            //add line
            self.addSubview(line)
            self.addSubview(v_black_r)

            label_name.snp.makeConstraints { (make) -> Void in
                
                label_name.font             = UIFont.systemFont(ofSize: 14)
                label_name.textColor        = UIColor.black
                label_name.textAlignment    = .center
          
                make.width.equalTo(self.snp.width)
                make.height.equalTo(15.h)
                make.center.equalTo(self.snp.center)
                
            }
            
            v_black_r.snp.makeConstraints { (make) -> Void in
                v_black_r.backgroundColor = UIColor.black
                make.width.equalTo(4.w)
                make.height.equalTo(18.w)
                make.right.equalTo(self.snp.right)
                make.centerY.equalTo(self.snp.centerY)
                v_black_r.isHidden = true
            }

 
        }
    }
    
    //左侧和右侧数据
    var vo_categories_arr           = [WOWFoundCategoryModel]()
    var vo_categories_sub_arr       = [WOWFoundCategoryModel]()
    var cid                         = 0
    let tv_width                    = 110.w
    
    
    var tv:UITableView!
    var cv:UICollectionView!

    func createTvLeft() {
        
        self.title           = "全部分类"
        tv                   = UITableView(frame:CGRect(x: 0, y: 0 , width: self.tv_width, height: MGScreenHeight), style:.plain)
        tv.separatorColor    = UIColor(hexString:"EAEAEA")
        tv.estimatedRowHeight  = 60.w
        
        tv.delegate          = self
        tv.dataSource        = self
        tv.register(TvCell.self, forCellReuseIdentifier:String(describing: TvCell()))
//        tv.bounces           = false
        tv.showsVerticalScrollIndicator = false
        self.view.addSubview(tv)
    }
    
    
    func createCvRight()  {
    
        let cv_width                           = MGScreenWidth - self.tv_width
        let padding                            = CGFloat(15)
        let cell_width                         = (cv_width  - padding * 3) / 2
        let cell_height                        = cell_width + 1 + 30
        let frame                              = CGRect( x: self.tv_width, y: 0, width: cv_width, height: MGScreenHeight)
        
        let layout                             = UICollectionViewFlowLayout()
        layout.scrollDirection                 = .vertical
        layout.sectionInset                    = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        
        layout.itemSize                        = CGSize(width:cell_width , height: cell_height)
//      layout.estimatedItemSize               = CGSize(width: cv_width / 2 - CGFloat(2), height: 100 )

        layout.minimumInteritemSpacing         = padding
        layout.minimumLineSpacing              = padding
        
        cv                                     = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        cv.delegate                             = self
        cv.dataSource                           = self
        cv.backgroundColor                      = UIColor(hue:0.00, saturation:0.00, brightness:0.96, alpha:1.00)
        cv.backgroundView                       = UIView(frame:CGRect.zero)
        
        
        cv.register(CVCell.self, forCellWithReuseIdentifier:String(describing: CVCell()))
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
        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category_subCategory_with_image(categoryId:cid), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{

                let r                             =  JSON(result)
                strongSelf.vo_categories_arr      =  Mapper<WOWFoundCategoryModel>().mapArray(JSONObject: r["categoryProductImgVoList"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.tv.reloadData()
                
                //默认选中第一个 触发collection变化
                let indexPath = IndexPath(row: 0, section: 0)
                strongSelf.tv.selectRow(  at: indexPath , animated: true, scrollPosition: UITableViewScrollPosition.top)
                strongSelf.tableView(strongSelf.tv, didSelectRowAt: indexPath)
                
            }
            
        }){ (errorMsg) in
            print(errorMsg)
            
            WOWHud.dismiss()

        }
    }
    
    func request_sub_cid(_ cid:Int) {
    
        WOWHud.showLoading()

        WOWNetManager.sharedManager.requestWithTarget(RequestApi.api_Category_subCategory_with_image(categoryId:cid), successClosure: {[weak self] (result) in
            
            if let strongSelf = self{
                
                let r                             =  JSON(result)
                


                strongSelf.vo_categories_sub_arr  =  Mapper<WOWFoundCategoryModel>().mapArray(JSONObject: r["categoryProductImgVoList"].arrayObject ) ?? [WOWFoundCategoryModel]()
                strongSelf.cv.reloadData()
                
             
                //默认选中第一个
                let indexPath = IndexPath(row: 0, section: 0)
                strongSelf.cv.scrollToItem(at: indexPath, at: .top, animated: false)
                strongSelf.cv.setContentOffset(CGPoint.zero, animated: false)

                WOWHud.dismiss()

            }
            
        }){ (errorMsg) in
            print(errorMsg)
            WOWHud.dismiss()

        }
    }

    
    
}

extension VCCategoryChoose:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return vo_categories_arr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: String(describing: TvCell()), for: indexPath) as! TvCell
        cell.selectionStyle     = .none
        let model               = vo_categories_arr[(indexPath as NSIndexPath).section]
        cell.setModel(model)
        
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
//    {
//        return 60.w
//        
//    }
//    func tableView( tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
//        return 60.w
//    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = vo_categories_arr[(indexPath as NSIndexPath).section]

        if let cid = m.categoryID {
            request_sub_cid(cid)
        }

    }
}

extension VCCategoryChoose:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let c = self.vo_categories_sub_arr.count
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell            = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CVCell()), for: indexPath) as! CVCell
        let m               = vo_categories_sub_arr[(indexPath as NSIndexPath).item]
        cell.setModel(m)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let m = vo_categories_sub_arr[(indexPath as NSIndexPath).item]
        if let cid = m.categoryID , let cname = m.categoryName{
                toVCCategory( cid ,cname: cname)
        }
 
    }
}
